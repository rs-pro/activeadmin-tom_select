# Migration Guide: ActiveAdmin Tom Select (Tailwind v4)

This guide helps you migrate from `activeadmin-searchable_select` to `activeadmin-tom_select` on ActiveAdmin 4.0.0.beta19 with Tailwind CSS v4.

## Quick Start (New Installation)

```bash
# Gem
bundle add activeadmin-tom_select

# NPM
npm install activeadmin-tom_select tom-select
```

## Why Update?

- Tom Select replaces Select2 (no jQuery)
- ActiveAdmin 4.0.0.beta19 compatible
- Tailwind CSS v4 styles included
- Auto-init helpers for searchable selects

## 1. Update Gemfile

```ruby
# Remove legacy gem(s)
# gem "activeadmin-searchable_select"
# gem "rs-activeadmin-searchable_select"

gem "activeadmin-tom_select", "~> 4.1.0"
```

## 2. Update JavaScript Dependencies

```bash
npm uninstall @codevise/activeadmin-searchable_select activeadmin-searchable_select jquery select2
npm install activeadmin-tom_select tom-select
```

## 3. JavaScript Imports

```javascript
import "@activeadmin/activeadmin";

import TomSelect from "tom-select";
window.TomSelect = TomSelect;

import { setupAutoInit } from "activeadmin-tom_select";
setupAutoInit();
```

## 4. Tailwind CSS Build (ActiveAdmin 4.0.0.beta19)

### 4.1 Tailwind Input

```css
/* app/assets/stylesheets/active_admin.tailwind.css */
@import "tailwindcss";
@config "../../../tailwind-active_admin.config.mjs";

@import "activeadmin-tom_select/css";
```

### 4.2 Tailwind Config (ESM)

```javascript
// tailwind-active_admin.config.mjs
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
    "./app/views/active_admin/**/*.{arb,erb,html,rb}",
    "./app/views/admin/**/*.{arb,erb,html,rb}",
    "./app/views/layouts/active_admin*.{erb,html}",
    "./app/javascript/**/*.js"
  ],
  darkMode: "selector",
  plugins: [activeAdminPlugin]
};
```

### 4.3 Tailwind Build Tasks

```ruby
# lib/tasks/active_admin.rake
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

  desc "Watch Active Admin Tailwind stylesheets"
  task watch: :environment do
    command = [
      Rails.root.join("bin/tailwindcss").to_s,
      "--watch",
      "-i", Rails.root.join("app/assets/stylesheets/active_admin.tailwind.css").to_s,
      "-o", Rails.root.join("app/assets/builds/active_admin.css").to_s,
      "-m"
    ]

    system(*command, exception: true)
  end
end

Rake::Task["assets:precompile"].enhance(["active_admin:build"])
Rake::Task["spec:prepare"].enhance(["active_admin:build"]) if Rake::Task.task_defined?("spec:prepare")
Rake::Task["db:test:prepare"].enhance(["active_admin:build"]) if Rake::Task.task_defined?("db:test:prepare")
```

### 4.4 package.json scripts

```json
{
  "scripts": {
    "build:js": "esbuild app/javascript/*.* --bundle --sourcemap --format=esm --outdir=app/assets/builds --public-path=/assets",
    "build:css": "bundle exec rake active_admin:build",
    "build": "npm run build:js && npm run build:css",
    "watch:css": "bundle exec rake active_admin:watch"
  }
}
```

### 4.5 Tailwind CLI binstub

```bash
bundle binstubs tailwindcss-ruby --force
```

## 5. Importmap (Optional)

```ruby
# config/importmap.rb
pin "tom-select", to: "https://ga.jspm.io/npm:tom-select@2.4.3/dist/js/tom-select.complete.min.js"
pin "activeadmin-tom_select", to: "activeadmin-tom_select.js"
```

## 6. ActiveAdmin Usage

```ruby
ActiveAdmin.register Product do
  form do |f|
    f.inputs do
      f.input :category, as: :searchable_select
      f.input :tags, as: :searchable_select, ajax: true, multiple: true
    end
    f.actions
  end

  filter :category, as: :searchable_select
  filter :tags, as: :searchable_select, ajax: true, multiple: true
end
```

## Troubleshooting

### Styles missing
- Confirm `app/assets/builds/active_admin.css` exists.
- Verify `active_admin.tailwind.css` imports `activeadmin-tom_select/css`.

### Tom Select not initializing
- Ensure `window.TomSelect` is set.
- Ensure `setupAutoInit()` runs.

## ActiveAdmin 4.0.0.beta19 Notes (from upgrade guide)

- `_site_header.html.erb` container class changed from `sticky` to `fixed`.
- `active_admin.html.erb` adds the `pt-16` utility class.
- Tailwind v4 requires `@import "tailwindcss"` + `@config`.
- jQuery and jQuery UI removed; `columns` and `tabs` removed.
- Replace `default_main_content` with `render "show_default"`.
- Replace `as: :datepicker` with `as: :date_picker`.
- Replace `active_admin_comments` with `active_admin_comments_for(resource)`.
- Replace `attributes_table` with `attributes_table_for(resource)` in sidebars.
