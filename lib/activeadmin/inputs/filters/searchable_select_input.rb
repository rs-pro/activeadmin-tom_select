module ActiveAdmin
  module Inputs
    module Filters
      # Searchable select input type for ActiveAdmin filters.
      #
      # @see ActiveAdmin::SearchableSelect::SelectInputExtension
      #   SelectInputExtension for list of available options.
      class SearchableSelectInput < SelectInput
        include ActiveAdmin::SearchableSelect::SelectInputExtension

        # Override to remove the empty "Any" option since we're using
        # Tom Select's clear button plugin instead
        def input_options
          super.merge(include_blank: false)
        end
      end
    end
  end
end
