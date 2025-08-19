# Repository Guidelines

## Project Structure & Module Organization
- `lib/`: Ruby engine, extensions, and DSL (`activeadmin/searchable_select/*`).
- `app/assets/`: Legacy Sprockets assets for ActiveAdmin (JS/CSS entry points).
- `src/`: ESM sources for the npm package (`searchable_select.js/.scss`).
- `vendor/assets/javascripts/`: Importmap-friendly JS build.
- `spec/`: RSpec suite with a Combustion Rails app under `spec/internal` and feature specs.
- `docs/`: Setup and integration guides.

## Build, Test, and Development Commands
- `bundle && bundle exec rspec`: Install gems and run tests.
- `appraisal install && appraisal rspec`: Test against Rails/ActiveAdmin matrices (see `Appraisals`).
- `bundle exec rubocop --force-exclusion`: Lint Ruby code per `.rubocop.yml`.
- `npm ci && npm run prepublishOnly`: Prepare npm publish artifacts from `app/assets` into `src/`.
- `npx playwright install chromium`: Install browser for JS feature specs (once locally).
- `rake build` / `rake release`: Gem build/release tasks (bundler gem tasks).

## Coding Style & Naming Conventions
- Ruby: 2-space indent, TargetRuby 3.0, max line length 100. Follow RuboCop rules in `.rubocop.yml`.
- Files/names: Ruby files under `lib/activeadmin/searchable_select/` use snake_case; modules under `ActiveAdmin::SearchableSelect`.
- JS: ESM modules in `src/`; keep imports explicit. Do not rely on global jQuery except where required by ActiveAdmin integration.

## Testing Guidelines
- Framework: RSpec. Feature/system specs use Capybara with Playwright; unit/integration specs run via Combustion.
- Run: `bundle exec rspec` (set `HEADLESS=false` to see browser during JS specs).
- Layout: place feature specs in `spec/features/**`. Use `type: :feature, js: true` when Select2/UI is involved.
- Matrix: validate with `appraisal rspec` before PRs.

## Commit & Pull Request Guidelines
- Commits: Use imperative, concise messages (e.g., "Fix Select2 init on esbuild"). Group related changes.
- PRs: Include clear description, linked issues, and rationale. Add screenshots/GIFs for UI-facing changes. Update `README.md`/`docs/` and `CHANGELOG.md` when behavior changes.
- Quality gate: Ensure `rspec` and `rubocop` pass locally; for npm changes, run `npm run prepublishOnly` to verify `src/` packaging.

## Notes for JS Integration
- For bundlers (esbuild/webpack): import `jquery` and `select2`, then call `select2($)` before importing this package; ensure `window.$ = window.jQuery = $`.
- For importmap: use `vendor/assets/javascripts/activeadmin-searchable_select.js`.

