require 'rails/generators'

module ActiveAdmin
  module TomSelect
    module Generators
      class InstallGenerator < Rails::Generators::Base
        source_root File.expand_path('templates', __dir__)

        desc 'Installs ActiveAdmin Tom Select for ActiveAdmin 4.x'

        class_option :bundler,
                     type: :string,
                     default: 'esbuild',
                     desc: 'JavaScript bundler to use (esbuild, importmap, webpack)',
                     enum: %w[esbuild importmap webpack]

        def install_npm_package
          return unless options[:bundler] != 'importmap'

          say 'Installing @rocket-sensei/activeadmin-tom_select npm package...', :green
          run 'npm install @rocket-sensei/activeadmin-tom_select'
        end

        def setup_javascript
          case options[:bundler]
          when 'esbuild'
            setup_esbuild
          when 'importmap'
            setup_importmap
          when 'webpack'
            setup_webpack
          end
        end

        def setup_stylesheets
          say 'Tom Select styles are now included in the package', :green
        end

        def show_post_install_message
          say "\n✅ ActiveAdmin Tom Select has been installed!", :green

          case options[:bundler]
          when 'esbuild'
            say "\nMake sure to rebuild your JavaScript:", :yellow
            say '  npm run build', :cyan
            say "\nFor development with watch mode:", :yellow
            say '  npm run build -- --watch', :cyan
          when 'importmap'
            say "\nRestart your Rails server to load the new pins.", :yellow
          when 'webpack'
            say "\nRecompile your webpack bundles:", :yellow
            say '  bin/webpack', :cyan
          end

          say "\n📚 Usage example:", :green
          say <<~RUBY

            # In your ActiveAdmin resource:
            ActiveAdmin.register User do
              searchable_select_options(
                scope: User.all,
                text_attribute: :name
              )
            end

            ActiveAdmin.register Post do
              form do |f|
                f.inputs do
                  f.input :user, as: :searchable_select, ajax: true
                end
                f.actions
              end
            end
          RUBY
        end

        PACKAGE_JSON_FILE = 'package.json'.freeze

        private

        def setup_esbuild
          say 'Setting up for esbuild...', :green

          # Check if app/javascript/active_admin.js exists
          js_file = 'app/javascript/active_admin.js'

          if File.exist?(js_file)
            say "Adding tom_select to #{js_file}...", :green
            append_to_file js_file do
              <<~JS

                // ActiveAdmin Tom Select
                import '@rocket-sensei/activeadmin-tom_select';
              JS
            end
          else
            say "Creating #{js_file}...", :green
            create_file js_file do
              <<~JS
                import "@activeadmin/activeadmin";

                // ActiveAdmin Tom Select
                import '@rocket-sensei/activeadmin-tom_select';
              JS
            end
          end

          # Update package.json scripts if needed
          return unless File.exist?(PACKAGE_JSON_FILE)

          package_json = JSON.parse(File.read(PACKAGE_JSON_FILE))

          return if package_json['scripts'] && package_json['scripts']['build']

          say 'Adding build script to package.json...', :green
          package_json['scripts'] ||= {}
          package_json['scripts']['build'] =
            'esbuild app/javascript/*.* --bundle --sourcemap --format=esm ' \
            '--outdir=app/assets/builds --public-path=/assets'

          File.write(PACKAGE_JSON_FILE, JSON.pretty_generate(package_json))
        end

        def setup_importmap
          say 'Setting up for importmap...', :green

          # Add pins to importmap.rb
          if File.exist?('config/importmap.rb')
            say 'Adding pins to config/importmap.rb...', :green
            append_to_file 'config/importmap.rb' do
              <<~RUBY

                # ActiveAdmin Tom Select
                pin "activeadmin-tom_select", to: "activeadmin-tom_select.js"
              RUBY
            end
          end

          # Copy the vendor JavaScript file
          say 'Copying vendor JavaScript file...', :green
          copy_file '../../../../vendor/assets/javascripts/activeadmin-tom_select.js',
                    'app/assets/javascripts/activeadmin-tom_select.js'

          # Update application.js
          js_file = 'app/javascript/application.js'
          return unless File.exist?(js_file)

          say "Adding imports to #{js_file}...", :green
          append_to_file js_file do
            <<~JS

              // ActiveAdmin Tom Select
              import "activeadmin-tom_select"
            JS
          end
        end

        def setup_webpack
          say 'Setting up for webpack...', :green

          js_file = 'app/javascript/packs/active_admin.js'

          if File.exist?(js_file)
            say "Adding tom_select to #{js_file}...", :green
            append_to_file js_file do
              <<~JS

                // ActiveAdmin Tom Select
                import '@rocket-sensei/activeadmin-tom_select';
              JS
            end
          else
            say 'Please manually add the tom_select import ' \
                'to your ActiveAdmin JavaScript pack', :yellow
          end
        end
      end
    end
  end
end
