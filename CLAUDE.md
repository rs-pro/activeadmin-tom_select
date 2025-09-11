# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ActiveAdmin Searchable Select is a Ruby gem that adds searchable select boxes (via Select2) to ActiveAdmin forms and filters. It extends the ActiveAdmin resource DSL to allow defining JSON endpoints for asynchronous option fetching.

## Development Commands

### Testing
```bash
# Run full test suite
bundle exec rspec

# Run tests against specific Rails/ActiveAdmin versions
appraisal install
appraisal rspec

# Run a specific test file
bundle exec rspec spec/features/end_to_end_spec.rb

# Run tests matching a pattern
bundle exec rspec -e "searchable select"
```

### Code Quality
```bash
# Run Rubocop for style checking
bundle exec rubocop

# Auto-fix Rubocop violations (when safe)
bundle exec rubocop -a
```

### Gem Management
```bash
# Install dependencies
bundle install

# Build gem
bundle exec rake build

# Release new version (via Semmy)
bundle exec rake release
```

### NPM Package
```bash
# Install npm dependencies
npm install

# Prepare source files for npm publishing
npm run prepublishOnly
```

## Architecture

### Core Components

1. **Input Extensions** (`lib/activeadmin/inputs/`)
   - `SearchableSelectInput`: Main form input class that renders searchable select fields
   - `filters/SearchableSelectInput`: Filter-specific variant for ActiveAdmin index pages

2. **Resource DSL Extension** (`lib/activeadmin/searchable_select/resource_dsl_extension.rb`)
   - Adds `searchable_select_options` method to ActiveAdmin resources
   - Defines collection actions that serve JSON endpoints for option fetching

3. **Option Collection** (`lib/activeadmin/searchable_select/option_collection.rb`)
   - Handles scope filtering via Ransack
   - Manages pagination and result formatting
   - Supports custom text attributes and display text lambdas

4. **JavaScript Integration** (`app/assets/javascripts/active_admin/`)
   - Initializes Select2 on searchable select inputs
   - Handles AJAX configuration for remote data fetching
   - Manages selected option rendering

### Request Flow for AJAX Options

1. User types in searchable select input
2. JavaScript sends AJAX request to `all_options_[resource]_path` 
3. Collection action (defined by `searchable_select_options`) processes request
4. `OptionCollection` applies Ransack filtering and pagination
5. JSON response returned with results and pagination metadata
6. Select2 renders options in dropdown

### Key Design Patterns

- **Ransack Integration**: All filtering leverages Ransack's query interface
- **Lazy Loading**: Options can be fetched asynchronously to handle large datasets
- **Scope Flexibility**: Scopes can be static collections or dynamic lambdas
- **Multiple Endpoints**: Single resource can define multiple option collections
- **Test Mode**: `inline_ajax_options` setting renders all options statically for testing

## Testing Approach

Tests use RSpec with Capybara for feature specs. The `spec/internal` directory contains a full Rails 8 application for testing.

### Running the Test App

```bash
# Start the test app for manual testing/demo
cd spec/internal
bundle exec rackup

# Or from project root
cd spec/internal && bundle exec rackup

# The app will be available at http://localhost:9292
# Default admin credentials: admin@example.com / password
```

### Test App Structure

The test app is a full Rails 8 application with:
- ActiveAdmin configured with Tailwind CSS
- Tom Select integrated for searchable select functionality
- Sample models (User, Category, Post, Color) with seed data
- Various admin resources demonstrating different searchable select configurations

### Building Assets in Test App

```bash
cd spec/internal

# Build CSS (Tailwind)
bundle exec rake active_admin:build

# Build JavaScript
npm run build:js

# Watch for changes during development
bundle exec rake active_admin:watch  # CSS
npm run watch:js                     # JavaScript
```

### Key Test Helpers

- `ActiveAdminHelpers`: Provides DSL for interacting with ActiveAdmin pages
- `inline_ajax_options` mode: Renders all options inline during feature tests
- Database cleaner ensures test isolation
- ABSOLUTELY NO GIT PUSH WITH --no-verify FLAG
- ABSOLUTELY NO GIT PUSH WITH --no-verify FLAG

## Recent Updates (2025)

### Tom Select Migration
- Migrated from Select2 to Tom Select for better performance and smaller bundle size
- Tom Select is now bundled with the gem (no external CDN dependency)
- Full Tailwind CSS styling support for Tom Select components

### Rails 8 Test App
- Replaced Combustion-based test app with full Rails 8 application
- Proper asset pipeline with esbuild and cssbundling-rails
- Tailwind CSS v3 integration with ActiveAdmin's Tailwind plugin
- Complete test environment for manual testing and development