module ActiveAdmin
  module TomSelect
    # Mixin for searchable select inputs.
    #
    # Supports the same options as inputs of type `:select`.
    #
    # Adds support for an `ajax` option to fetch options data from a
    # JSON endpoint. Pass either `true` to use defaults or a hash
    # containing some of the following options:
    #
    # - `resource`: ActiveRecord model class of ActiveAdmin resource
    #    which provides the collection action to fetch options
    #    from. By default the resource is auto detected via the name
    #    of the input attribute.
    #
    # - `collection_name`: Name passed to the
    #   `searchable_select_options` method that defines the collection
    #   action to fetch options from.
    #
    # - `params`: Hash of query parameters that shall be passed to the
    #   options endpoint.
    #
    # - `path_params`: Hash of parameters, which would be passed to the
    #   dynamic collection path generation for the resource.
    #   e.g `admin_articles_path(path_params)`
    #
    # If the `ajax` option is present, the `collection` option is
    # ignored.
    module SelectInputExtension # rubocop:disable Metrics/ModuleLength
      # @api private
      def to_html
        super
      rescue RuntimeError => e
        # Display helpful error message
        error_html = e.message.gsub("\n", '<br>').html_safe
        error_style = 'color: red; padding: 10px; background: #fee; ' \
                      'border: 1px solid #fcc; border-radius: 4px; margin: 5px 0;'
        template.content_tag(:div, error_html, class: 'searchable-select-error', style: error_style)
      end

      # @api private
      def input_html_options
        super.tap do |options|
          add_css_class(options)
          add_data_attributes(options)
        end
      end

      # @api private
      # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
      # rubocop:disable Metrics/PerceivedComplexity
      def collection_from_options
        if ajax?
          collection = if TomSelect.inline_ajax_options
                         all_options_collection
                       else
                         selected_value_collection
                       end

          # Remove any empty/blank options since we use clear button instead
          collection.reject { |item| item.first.to_s.strip.empty? && item.last.to_s.strip.empty? }
        else
          # When not using ajax, get the original collection
          collection = super
          # Add empty option at the beginning if not present to prevent auto-selection
          if collection.present? && collection.none? { |item| item.last.to_s.strip.empty? }
            [['', '']] + collection
          else
            collection
          end
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
      # rubocop:enable Metrics/PerceivedComplexity

      private

      def add_css_class(options)
        css_class = self.class.name.demodulize.underscore.dasherize
        options[:class] = [options[:class], css_class].compact.join(' ')
      end

      def add_data_attributes(options)
        options['data-ajax-url'] = ajax_url if ajax? && !TomSelect.inline_ajax_options
        options['data-clearable'] = true if clearable?
      end

      def ajax?
        # Default to true unless explicitly set to false
        options[:ajax] != false
      end

      def clearable?
        # Default to true unless explicitly set to false
        options.fetch(:clearable, true)
      end

      def ajax_url
        return unless ajax?

        [ajax_resource.route_collection_path(path_params),
         '/',
         option_collection.collection_action_name,
         '?',
         ajax_params.to_query].join
      end

      def all_options_collection
        option_collection_scope.all.map do |record|
          option_for_record(record)
        end
      end

      def selected_value_collection
        selected_records.collect { |s| option_for_record(s) }
      end

      def option_for_record(record)
        [option_collection.display_text(record), record.id]
      end

      def selected_records
        @selected_records ||=
          if selected_values
            option_collection_scope.where(id: selected_values)
          else
            []
          end
      end

      def selected_values
        @object&.send(input_name)
      end

      def option_collection_scope
        option_collection.scope(template, path_params.merge(ajax_params))
      end

      def option_collection # rubocop:disable Metrics/MethodLength
        ajax_resource
          .searchable_select_option_collections
          .fetch(ajax_option_collection_name) do
          model_name = ajax_resource_class.name
          raise('The required ajax endpoint is missing. ' \
                "Add `searchable_select_options` to the '#{model_name}' admin resource:\n\n  " \
                "ActiveAdmin.register #{model_name} do\n    " \
                "searchable_select_options(scope: #{model_name},\n                               " \
                "text_attribute: :name)  # or :title, :email, etc.\n  " \
                "end\n\n" \
                "Or disable ajax mode for this input:\n  " \
                "f.input :#{method}, as: :searchable_select, ajax: false")
        end
      end

      def ajax_resource
        @ajax_resource ||=
          template.active_admin_namespace.resource_for(ajax_resource_class) ||
          raise("No admin found for '#{ajax_resource_class.name}' to fetch " \
                'options for searchable select input from.')
      end

      def ajax_resource_class
        ajax_options.fetch(:resource) do
          raise_cannot_auto_detect_resource unless reflection
          reflection.klass
        end
      end

      def raise_cannot_auto_detect_resource
        raise('Cannot auto detect resource to fetch options for searchable select input from. ' \
              "Explicitly pass class of an ActiveAdmin resource:\n\n  " \
              "f.input(:custom_category,\n          " \
              "type: :searchable_select,\n          " \
              "ajax: {\n            " \
              "resource: Category\n          " \
              "})\n")
      end

      def ajax_option_collection_name
        ajax_options.fetch(:collection_name, :all)
      end

      def ajax_params
        ajax_options.fetch(:params, {})
      end

      def path_params
        ajax_options.fetch(:path_params, {})
      end

      def ajax_options
        # ActiveAdmin 4 may transform ajax hash to boolean
        return {} if options[:ajax] == true || options[:ajax].nil?

        options[:ajax]
      end
    end
  end
end
