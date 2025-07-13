require 'rails_helper'
require 'fileutils'
require 'open3'
require 'net/http'

RSpec.describe 'Demo Application', type: :feature do
  let(:demo_app_path) { Rails.root.join('tmp', 'demo_app') }
  
  before(:all) do
    # Clean up any existing demo app
    FileUtils.rm_rf(Rails.root.join('tmp', 'demo_app'))
  end
  
  after(:all) do
    # Clean up after tests
    FileUtils.rm_rf(Rails.root.join('tmp', 'demo_app'))
  end
  
  it 'generates a working demo application' do
    # Create a new Rails app
    Dir.chdir(Rails.root.join('tmp')) do
      system("rails new demo_app --skip-bundle --skip-test --skip-system-test --database=sqlite3")
    end
    
    # Add our gem to the Gemfile
    File.open(demo_app_path.join('Gemfile'), 'a') do |f|
      f.puts "\ngem 'activeadmin-searchable_select', path: '#{File.expand_path('../..', __dir__)}'"
      f.puts "gem 'activeadmin', '~> #{active_admin_version.to_i}.0'"
      f.puts "gem 'sassc-rails'" if active_admin_version.to_i < 4
      f.puts "gem 'devise'"
      f.puts "gem 'bootsnap', require: false"
    end
    
    Dir.chdir(demo_app_path) do
      # Install dependencies
      system("bundle install")
      
      # Setup ActiveAdmin
      system("rails generate active_admin:install --skip-users")
      system("rails db:migrate")
      
      # Generate a test model
      system("rails generate model Product name:string category:string")
      system("rails db:migrate")
      
      # Create ActiveAdmin resource with searchable select
      File.write('app/admin/products.rb', <<~RUBY)
        ActiveAdmin.register Product do
          searchable_select_options(scope: Product, text_attribute: :name)
          
          permit_params :name, :category
          
          form do |f|
            f.inputs do
              f.input :name
              f.input :category, as: :searchable_select, 
                      ajax: { resource: Product, text_attribute: :name }
            end
            f.actions
          end
          
          filter :name
          filter :category, as: :searchable_select, 
                  ajax: { resource: Product, text_attribute: :name }
        end
      RUBY
      
      # Create some test data
      File.write('db/seeds.rb', <<~RUBY)
        Product.create!([
          { name: 'Product 1', category: 'Category A' },
          { name: 'Product 2', category: 'Category B' },
          { name: 'Product 3', category: 'Category A' }
        ])
      RUBY
      
      system("rails db:seed")
      
      # Test that the server starts without errors
      server_pid = spawn("rails server -p 3001", err: "/dev/null", out: "/dev/null")
      
      begin
        # Wait for server to start
        sleep 5
        
        # Check if server is running
        response = Net::HTTP.get_response(URI('http://localhost:3001/admin'))
        expect(response.code).to eq('200').or eq('302') # 302 for redirect to login
      ensure
        Process.kill('TERM', server_pid)
        Process.wait(server_pid)
      end
    end
  end
  
  describe 'with browser testing', js: true do
    before do
      skip "Browser tests require full setup" unless ENV['RUN_BROWSER_TESTS']
    end
    
    it 'shows searchable select in forms' do
      visit '/admin/products/new'
      
      # Check that searchable select is rendered
      expect(page).to have_css('.searchable-select-input')
      
      # Test Select2 functionality
      find('.select2-container').click
      expect(page).to have_css('.select2-dropdown')
    end
    
    it 'shows searchable select in filters' do
      visit '/admin/products'
      
      # Open filters
      click_on 'Filter'
      
      # Check that searchable select is in filters
      within '.filter_form' do
        expect(page).to have_css('.searchable-select-input')
      end
    end
  end
end