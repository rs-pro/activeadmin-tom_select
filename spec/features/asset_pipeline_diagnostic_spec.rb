require 'rails_helper'

RSpec.describe 'Asset Pipeline Diagnostics', type: :feature do
  describe 'Asset Configuration' do
    it 'verifies all asset pipeline components are properly configured', js: true do
      errors = []

      # 1. Check Propshaft is loaded
      if defined?(Rails.application.assets)
        # 2. Check asset paths are configured
        errors << 'No asset paths configured' if Rails.application.assets.load_path.paths.empty?

        # 3. Check resolver type
        unless Rails.application.assets.resolver.is_a?(Propshaft::Resolver::Dynamic)
          errors << "Wrong resolver type: #{Rails.application.assets.resolver.class}"
        end
      else
        errors << 'Rails.application.assets not defined - Propshaft not loaded'
      end

      # 4. Check built assets exist and contain expected content
      builds_path = Rails.root.join('app/assets/builds')
      if File.exist?(builds_path)
        # Check JavaScript file
        js_file = File.join(builds_path, 'active_admin.js')
        if File.exist?(js_file)
          js_content = File.read(js_file)
          js_checks = {
            'TomSelect class' => js_content.include?('TomSelect'),
            'initSearchableSelects function' => js_content.include?('initSearchableSelects'),
            'window.TomSelect assignment' => js_content.include?('window.TomSelect'),
            'DOMContentLoaded listener' => js_content.include?('DOMContentLoaded'),
            'searchable-select-input selector' => js_content.include?('searchable-select-input')
          }

          js_checks.each do |check, present|
            errors << "JavaScript missing: #{check}" unless present
          end
        else
          errors << 'active_admin.js not found in builds directory'
        end

        # Check CSS file
        css_file = File.join(builds_path, 'active_admin.css')
        if File.exist?(css_file)
          css_content = File.read(css_file)
          css_checks = {
            'ts-wrapper styles' => css_content.include?('.ts-wrapper'),
            'ts-control styles' => css_content.include?('.ts-control'),
            'ts-dropdown styles' => css_content.include?('.ts-dropdown')
          }

          css_checks.each do |check, present|
            errors << "CSS missing: #{check}" unless present
          end
        else
          errors << 'active_admin.css not found in builds directory'
        end
      else
        errors << "Builds directory does not exist at #{builds_path}"
      end

      # 5. Test actual asset serving in browser
      visit '/admin/posts'

      # Check if assets are loaded in browser
      js_loaded = page.evaluate_script("typeof window.TomSelect !== 'undefined'")
      errors << 'TomSelect not loaded in browser' unless js_loaded

      init_loaded = page.evaluate_script("typeof window.initSearchableSelects !== 'undefined'")
      errors << 'initSearchableSelects not loaded in browser' unless init_loaded

      # Check if Tom Select initialized
      inputs = page.evaluate_script("document.querySelectorAll('.searchable-select-input').length")
      ts_wrappers = page.evaluate_script("document.querySelectorAll('.ts-wrapper').length")

      if inputs > 0 && ts_wrappers == 0
        errors << "Tom Select not initializing (#{inputs} inputs but 0 wrappers)"
      end

      # Only print diagnostic info if there are errors
      if errors.any?
        puts "\n#{'=' * 80}"
        puts 'ASSET PIPELINE DIAGNOSTIC FAILURES'
        puts '=' * 80

        errors.each do |error|
          puts "  ✗ #{error}"
        end

        # Print additional debugging info
        puts "\nDEBUG INFO:"
        puts '-' * 40

        if defined?(Rails.application.assets)
          puts "Asset paths (#{Rails.application.assets.load_path.paths.count}):"
          Rails.application.assets.load_path.paths.each { |path| puts "  - #{path}" }

          puts "\nResolver: #{Rails.application.assets.resolver.class}"
        end

        if File.exist?(builds_path)
          puts "\nBuilt files:"
          Dir.glob(File.join(builds_path, '*')).each do |file|
            puts "  - #{File.basename(file)}: #{File.size(file)} bytes"
          end
        end

        # Check asset URLs in page
        html = page.html
        js_tags = html.scan(/<script[^>]*src=["']([^"']+)["'][^>]*>/).flatten
        css_tags = html.scan(/<link[^>]*href=["']([^"']+\.css[^"']*)["'][^>]*>/).flatten

        puts "\nAsset tags in HTML:"
        puts "  JS: #{js_tags.join(', ')}"
        puts "  CSS: #{css_tags.join(', ')}"

        puts "\nBrowser state:"
        puts "  Inputs found: #{inputs}"
        puts "  Tom Select wrappers: #{ts_wrappers}"

        puts '=' * 80
      end

      # Fail the test if there are any errors
      expect(errors).to be_empty
    end
  end

  describe 'Asset Serving in Test Mode', js: true do
    it 'serves assets correctly through Propshaft' do
      visit '/admin/posts'

      # Check that assets are served with digest URLs
      js_url = page.evaluate_script("document.querySelector('script[src*=\"active_admin\"]')?.src")
      css_url = page.evaluate_script("document.querySelector('link[href*=\"active_admin\"]')?.href")

      # Only check if URLs exist and use /assets/ path
      expect(js_url).to match(%r{/assets/active_admin-[a-f0-9]+\.js})
      expect(css_url).to match(%r{/assets/active_admin-[a-f0-9]+\.css})

      # Check that assets actually load
      if js_url
        response = Net::HTTP.get_response(URI(js_url))
        expect(response.code).to eq('200')
        expect(response.body).to include('TomSelect')
      end

      if css_url
        response = Net::HTTP.get_response(URI(css_url))
        expect(response.code).to eq('200')
      end
    end
  end
end
