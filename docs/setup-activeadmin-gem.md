# Setting Up an ActiveAdmin 4 Extension Gem (Combustion)

This guide mirrors the working setup used in this repo: ActiveAdmin 4.0.0.beta20 + Tailwind CSS v4 + Combustion test app.

## 1. Gem Dependencies

```ruby
# Gemfile
source "https://rubygems.org"
gemspec

gem "rails", "~> 7.2"
gem "activeadmin", "4.0.0.beta20"
gem "sqlite3"
gem "puma"

gem "importmap-rails", "~> 2.0"
gem "propshaft"

gem "tailwindcss-rails", "~> 4.4.0"

group :development, :test do
  gem "combustion", "~> 1.3"
  gem "rspec-rails"
  gem "capybara"
end
```

## 2. Combustion Test App

```bash
bundle exec combust
```

## 3. config.ru Loading Order

```ruby
# config.ru
require "rubygems"
require "bundler"

Bundler.setup(:default, :development)

require "combustion"
Combustion.initialize! :active_record, :action_controller, :action_view do
  config.load_defaults Rails::VERSION::STRING.to_f if Rails::VERSION::MAJOR >= 7
end

require "importmap-rails"
require "active_admin"
require "activeadmin_your_feature"

run Combustion::Application
```

## 4. Internal App Structure

```bash
cd spec/internal
mkdir -p app/admin app/assets/{builds,config,stylesheets} app/javascript
```

## 5. ActiveAdmin Setup

```ruby
# spec/internal/config/initializers/active_admin.rb
ActiveAdmin.setup do |config|
  config.site_title = "Test App"
  config.authentication_method = false
  config.current_user_method = false
end
```

## 6. Tailwind Input + Config

```css
/* spec/internal/app/assets/stylesheets/active_admin.tailwind.css */
@import "tailwindcss";
@config "../../../tailwind-active_admin.config.mjs";

/* Import your gem CSS if needed */
@import "your_gem/css";
```

```javascript
// spec/internal/tailwind-active_admin.config.mjs
import { execSync } from "child_process";
import activeAdminPlugin from "@activeadmin/activeadmin/plugin";

const activeAdminPath = execSync("bundle show activeadmin", {
  encoding: "utf-8"
}).trim();

export default {
  content: [
    `${activeAdminPath}/vendor/javascript/flowbite.js`,
    `${activeAdminPath}/plugin.js`,
    `${activeAdminPath}/app/views/**/*.{arb,erb,html,rb}`,
    "./app/admin/**/*.{arb,erb,html,rb}",
    "./app/views/**/*.{arb,erb,html,rb}",
    "./app/javascript/**/*.js",
    "../../app/assets/**/*.{js,css}"
  ],
  darkMode: "selector",
  plugins: [activeAdminPlugin]
};
```

## 7. Tailwind Build Tasks

```ruby
# spec/internal/lib/tasks/active_admin.rake
namespace :active_admin do
  desc "Build Active Admin Tailwind stylesheets"
  task build: :environment do
    command = [
      Rails.root.join("bin/tailwindcss").to_s,
      "-i", Rails.root.join("app/assets/stylesheets/active_admin.tailwind.css").to_s,
      "-o", Rails.root.join("app/assets/builds/active_admin.css").to_s,
      "-m"
    ]

    system(*command, exception: true)
  end
end
```

## 8. Tailwind Binstub

```bash
bundle binstubs tailwindcss-ruby --force
```

## 9. JS Entry

```javascript
// spec/internal/app/javascript/active_admin.js
import "@activeadmin/activeadmin";
import "your_gem";
```

## 10. package.json (internal)

```json
{
  "name": "internal",
  "private": true,
  "scripts": {
    "build:js": "node esbuild.config.js",
    "build:css": "bundle exec rake active_admin:build",
    "build": "npm run build:js && npm run build:css"
  },
  "devDependencies": {
    "@activeadmin/activeadmin": "^4.0.0-beta20",
    "esbuild": "^0.24.2"
  }
}
```

## 11. ActiveAdmin 4.0.0.beta20 Notes (from upgrade guide)

**Version Requirements:**
- Rails 7.2+ (Rails 7.0 and 7.1 are no longer supported)
- Ruby 3.2+ (Ruby 3.0 and 3.1 are no longer supported)

**Breaking Changes from earlier v4 betas:**
- `_site_header.html.erb` container class changed from `sticky` to `fixed`.
- `active_admin.html.erb` adds the `pt-16` utility class.
- Tailwind v4 requires `@import "tailwindcss"` + `@config`.
- jQuery and jQuery UI removed; `columns` and `tabs` components removed.
- Replace `default_main_content` with `render "show_default"`.
- Replace `as: :datepicker` with `as: :date_picker`.
- Replace `active_admin_comments` with `active_admin_comments_for(resource)`.
- Replace `attributes_table` with `attributes_table_for(resource)` in sidebars.

**New in beta20:**
- Parent menu item linking support
- Improved comments pagination styling
- Better vertical spacing for has-many forms
- Pointer cursor restored on eligible buttons
- Various accessibility improvements
