# ActiveAdmin + Tailwind CSS v4 Guide

This guide consolidates the ActiveAdmin 4.0.0.beta19 upgrade notes with a working Tailwind v4 build setup. Use it as a template when updating other ActiveAdmin extension gems.

## What Changed in ActiveAdmin 4.0.0.beta19 (from UPGRADING.md)

### Template Updates
- `_site_header.html.erb` container class changed from `sticky` to `fixed`.
- `active_admin.html.erb` now includes the `pt-16` utility class.

### Tailwind v4 Updates
Replace the old Tailwind directives with the new v4 import and config:

```diff
-@tailwind base;
-@tailwind components;
-@tailwind utilities;
+@import "tailwindcss";
+
+@config "../../../tailwind-active_admin.config.mjs";
```

Update your CSS build command:

```diff
-"build:css": "tailwindcss -i ./app/assets/stylesheets/active_admin.css -o ./app/assets/builds/active_admin.css --minify -c tailwind-active_admin.config.js"
+"build:css": "npx @tailwindcss/cli -i ./app/assets/stylesheets/active_admin.css -o ./app/assets/builds/active_admin.css --minify"
```

If you use `tailwindcss-rails`, prefer the bundled `bin/tailwindcss` and the `@config` directive instead of passing `-c`.

### ESM Config Warning
Tailwind config now uses ESM. To avoid the warning:
- Rename `tailwind-active_admin.config.js` to `tailwind-active_admin.config.mjs`, or
- Add `"type": "module"` to `package.json`.

### Breaking Changes Summary
- jQuery and jQuery UI removed.
- `columns` component removed (use Tailwind grid).
- `tabs` component removed.
- Replace `default_main_content` with `render "show_default"`.
- Replace `as: :datepicker` with `as: :date_picker`.
- Replace `active_admin_comments` with `active_admin_comments_for(resource)`.
- Replace `attributes_table` with `attributes_table_for(resource)` in sidebars.
- Removed `IndexAsBlog`, `IndexAsBlock`, `IndexAsGrid`.
- Batch action form DSL replaced with partial support.
- Deeply nested submenus removed (only one level supported).
- Removed `Panel#header_action` and `index_column`.

## Recommended Build Setup (tailwindcss-rails)

### 1. Gemfile

```ruby
gem "activeadmin", "4.0.0.beta19"
gem "tailwindcss-rails", "~> 4.4.0"
```

### 2. Tailwind Input

```css
/* app/assets/stylesheets/active_admin.tailwind.css */
@import "tailwindcss";
@config "../../../tailwind-active_admin.config.mjs";
```

### 3. Tailwind Config

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

### 4. Build Tasks

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
end
```

### 5. Tailwind CLI Binstub

```bash
bundle binstubs tailwindcss-ruby --force
```

## Notes for Extension Gems

When updating other ActiveAdmin extension gems:
- Keep all JS/CSS inside the gem or npm package; do not copy large files into host apps.
- Add only a thin import to the host app (`import "your_gem"`).
- Use Tailwind v4 `@import` + `@config` and ESM config files.
- Avoid jQuery-based plugins or require them explicitly.
