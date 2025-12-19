# ActiveAdmin 4 Asset Setup (Tailwind CSS v4)

## Overview
This guide documents the current, working setup for ActiveAdmin 4.0.0.beta19 with Tailwind CSS v4 and Tom Select (no jQuery).

## Requirements
- ActiveAdmin 4.0.0.beta19
- Tailwind CSS v4 via `tailwindcss-rails` (ships `bin/tailwindcss`)
- ESBuild (or other JS bundler) for ActiveAdmin JS + Tom Select

## 1. Gemfile

```ruby
# ActiveAdmin 4 beta
gem "activeadmin", "4.0.0.beta19"

gem "activeadmin-tom_select"

# Tailwind CSS v4 (bundled CLI)
gem "tailwindcss-rails", "~> 4.4.0"
```

## 2. package.json

```json
{
  "dependencies": {
    "@activeadmin/activeadmin": "^4.0.0-beta19",
    "tom-select": "^2.4.3",
    "activeadmin-tom_select": "^4.1.0"
  },
  "devDependencies": {
    "esbuild": "^0.27.2"
  },
  "scripts": {
    "build:js": "node esbuild-active_admin.config.js",
    "build:css": "bundle exec rake active_admin:build",
    "build": "npm run build:js && npm run build:css",
    "watch:js": "node esbuild-active_admin.config.js --watch",
    "watch:css": "bundle exec rake active_admin:watch",
    "dev": "npm run watch:js & npm run watch:css"
  }
}
```

## 3. JavaScript Entry (app/javascript/active_admin.js)

```javascript
import "@activeadmin/activeadmin";

import TomSelect from "tom-select";
window.TomSelect = TomSelect;

import { setupAutoInit, initSearchableSelects } from "activeadmin-tom_select";
window.initSearchableSelects = initSearchableSelects;
setupAutoInit();
```

## 4. Tailwind Input (app/assets/stylesheets/active_admin.tailwind.css)

```css
@import "tailwindcss";
@config "../../../tailwind-active_admin.config.mjs";

@import "activeadmin-tom_select/css";
```

## 5. Tailwind Config (tailwind-active_admin.config.mjs)

```javascript
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

## 6. Tailwind Build Tasks (lib/tasks/active_admin.rake)

```ruby
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
Rake::Task["test:prepare"].enhance(["active_admin:build"]) if Rake::Task.task_defined?("test:prepare")
Rake::Task["spec:prepare"].enhance(["active_admin:build"]) if Rake::Task.task_defined?("spec:prepare")
Rake::Task["db:test:prepare"].enhance(["active_admin:build"]) if Rake::Task.task_defined?("db:test:prepare")
```

## 7. Tailwind CLI Binstub

```bash
bundle binstubs tailwindcss-ruby --force
```

## 8. Upgrade Notes (ActiveAdmin 4.0.0.beta19)

From ActiveAdmin's upgrade guide:
- `_site_header.html.erb` container class changed from `sticky` to `fixed`.
- `active_admin.html.erb` adds the `pt-16` utility class.
- Tailwind v4 uses `@import "tailwindcss"` and `@config` (no `@tailwind` directives).
- The Tailwind config file is ESM. Use `tailwind-active_admin.config.mjs`.
- jQuery/jQuery UI removed; `columns` and `tabs` components removed.
- Replace `default_main_content` with `render "show_default"`.
- Replace `as: :datepicker` with `as: :date_picker`.
- Replace `active_admin_comments` with `active_admin_comments_for(resource)`.
- Replace `attributes_table` with `attributes_table_for(resource)` in sidebars.

## Troubleshooting

### CSS not building
- Ensure `tailwindcss-rails` is pinned to `~> 4.4.0`.
- Run `bundle binstubs tailwindcss-ruby --force`.
- Confirm `bin/tailwindcss` exists.

### ActiveAdmin styles not loading
- Verify `app/assets/builds/active_admin.css` exists.
- Check that `active_admin.tailwind.css` imports `activeadmin-tom_select/css`.

### Tom Select not initializing
- Verify `window.TomSelect` in the console.
- Ensure `setupAutoInit()` is called.

## Migration Checklist

- [ ] Update ActiveAdmin to 4.0.0.beta19
- [ ] Use Tailwind v4 `@import` + `@config`
- [ ] Add `tailwindcss-rails` (~> 4.4.0) and binstub
- [ ] Create `tailwind-active_admin.config.mjs` (ESM)
- [ ] Update rake tasks to use `bin/tailwindcss` (no `-c`)
- [ ] Rebuild assets and verify UI
