# Repository Guidelines

## Project Structure & Module Organization
- `lib/`: Ruby engine, extensions, and DSL under `ActiveAdmin::TomSelect`.
- `app/assets/`: Legacy Sprockets JS/CSS entry points for ActiveAdmin.
- `src/`: ESM sources for the npm package (`searchable_select.js/.scss`).
- `vendor/assets/javascripts/`: Importmap-friendly JS build.
- `spec/`: RSpec suite with Combustion Rails app under `spec/internal`; feature specs in `spec/features/**`.
- `docs/`: Setup and integration guides.

## Build, Test, and Development Commands
- `bundle && bundle exec rspec`: Install gems and run the test suite.
- `appraisal install && appraisal rspec`: Run the Rails/ActiveAdmin matrix (see `Appraisals`).
- `bundle exec rubocop --force-exclusion`: Lint Ruby code per `.rubocop.yml`.
- `npm ci && npm run prepublishOnly`: Build npm artifacts from `app/assets` into `src/`.
- `npx playwright install chromium`: One-time browser install for JS feature specs.
- `rake build` / `rake release`: Build/release the gem via Bundler tasks.
- Example (headed browser): `HEADLESS=false bundle exec rspec`.

## Coding Style & Naming Conventions
- Ruby: 2-space indent, TargetRuby 3.0, max line length 100; follow RuboCop rules.
- Names: Ruby files in `lib/activeadmin/tom_select/` use snake_case; modules under `ActiveAdmin::TomSelect`.
- JS: ESM modules in `src/`; keep imports explicit. Avoid global jQuery except for ActiveAdmin integration.

## Testing Guidelines
- Framework: RSpec. Feature/system specs use Capybara with Playwright; unit/integration via Combustion.
- Layout: Place UI/Select2 specs under `spec/features/**` and tag `type: :feature, js: true`.
- Run: `bundle exec rspec` locally; use `appraisal rspec` to validate matrices before PRs.
- Browser: Install once with `npx playwright install chromium`. Use `HEADLESS=false` to visualize.

## Commit & Pull Request Guidelines
- Commits: Imperative, concise messages (e.g., "Fix Select2 init on esbuild"). Group related changes.
- PRs: Provide clear description, rationale, linked issues; add screenshots/GIFs for UI changes. Update `README.md`/`docs/` and `CHANGELOG.md` for behavior changes.
- Quality gate: Ensure `rspec` and `rubocop` pass; for npm-facing changes, run `npm run prepublishOnly` to verify `src/` packaging.

## JS Integration Notes
- Bundlers (esbuild/webpack): `import 'jquery'` and `import 'select2'`, then call `select2($)` and ensure `window.$ = window.jQuery = $` before importing this package.
- Importmap: Use `vendor/assets/javascripts/activeadmin-searchable_select.js`.

