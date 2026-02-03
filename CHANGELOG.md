# CHANGELOG

### Version 4.2.0.beta3

#### 🔄 Dependencies
- **ActiveAdmin Update**: Updated ActiveAdmin from 4.0.0.beta19 to 4.0.0.beta20
  - Now requires Rails 7.2+ (dropped support for Rails 7.0 and 7.1)
  - Added Ruby 4.0 to CI test matrix
- **Appraisal Updates**: Updated Appraisal gemfiles to use Rails 7.2 and ActiveAdmin 4.0.0.beta20

#### 📚 Documentation
- Added comprehensive ActiveAdmin v4.0.0 beta changelog to `docs/activeadmin-4-changelog.md`
  - Includes all changes from beta1 through beta20
  - Documents breaking changes, new features, and migration path

#### 🔧 Technical Improvements
- **CI Workflow**: Added Ruby 4.0 to test matrix for future compatibility

### Version 4.1.2

#### 🐛 Bug Fixes
- **SonarQube Integration**: Fixed coverage path issues preventing SonarQube from reading test coverage reports in CI
- **SimpleCov Configuration**: Reverted to standard SimpleCov JSON formatter for better compatibility
- **CI Workflow**: Improved coverage reporting by using absolute paths instead of relative paths

#### 🔧 Technical Improvements
- **Removed CodeCov**: Simplified CI by removing unused CodeCov integration (using SonarQube exclusively for coverage)
- **SonarQube Configuration**: Updated `sonar-project.properties` to include npm-package in sources and exclude built assets
- **Appraisal Updates**: Updated all Appraisal gemfiles to latest dependency versions

### Version 4.1.1

#### ✨ Improvements
- **New Input Type**: Added `TomSelectInput` as the primary input class, with `SearchableSelectInput` now as a legacy alias for backward compatibility
- **Module Renaming**: Renamed internal module from `ActiveAdmin::SearchableSelect` to `ActiveAdmin::TomSelect` for consistency
- **NPM Package Name**: Changed npm package name from `@rocket-sensei/activeadmin-tom_select` to `activeadmin-tom_select` (without organization prefix)
- **Style Fixes**:
  - Fixed dark mode background colors to match ActiveAdmin inputs (#374151)
  - Fixed dark mode text color visibility
  - Fixed border radius to match ActiveAdmin design (rounded-md)
  - Fixed full width styling for select inputs
- **Documentation**: Updated README to show `as: :tom_select` usage (with backward compatibility note)

#### 🔄 Migration
- New code should use `f.input :field, as: :tom_select`
- Legacy `as: :searchable_select` continues to work for backward compatibility
- NPM install command: `npm install activeadmin-tom_select` (no organization prefix)

### Version 4.1.0

[Compare changes](https://github.com/glebtv/activeadmin-searchable_select/compare/1-8-stable...master)

#### 🚀 Major Breaking Change: Migration from Select2 to Tom Select

This release represents a complete overhaul of the underlying select library, moving from jQuery-based Select2 to the modern, vanilla JavaScript Tom Select library.

#### ✨ New Features
- **Tom Select Integration**: Replaced Select2 with Tom Select v2.4.3 for better performance and smaller bundle size
- **jQuery-Free**: Completely removed jQuery dependency, reducing bundle size significantly
- **Tailwind CSS Support**: Added full Tailwind CSS 3 support with custom styled components
- **Modern JavaScript**: Rewritten with ES6+ modules and native browser APIs
- **TypeScript Ready**: Tom Select provides TypeScript definitions out of the box
- **Improved Performance**: Faster initialization and better memory management

#### 💔 Breaking Changes
- **No jQuery Required**: Applications no longer need jQuery for searchable selects
- **CSS Class Changes**: All Select2 classes replaced with Tom Select equivalents:
  - `.select2-container` → `.ts-wrapper` or `.ts-control`
  - `.select2-dropdown` → `.ts-dropdown`
  - `.select2-results__option` → `.ts-dropdown .option`
  - `.select2-selection` → `.ts-control .item`
  - `.select2-search__field` → `.ts-control input`
- **JavaScript API Changes**: Tom Select has different initialization and options
- **Removed Legacy Files**: `searchable_select/init.js` no longer exists

#### 🔧 Technical Improvements
- **Build Process**: Simplified build process using Tailwind CSS 3 and esbuild
- **CSS Architecture**: Consolidated all styles into a single `tom-select-tailwind.css` file
- **Test Updates**: Updated all test selectors to work with Tom Select
- **Package Exports**: Updated npm package exports for Tom Select styles
- **Documentation**: Added comprehensive migration guide at `/docs/update-tom-select.md`

#### 📦 Dependencies
- **Removed**:
  - `jquery` (peer dependency)
  - `select2` (peer dependency)
- **Added**:
  - `tom-select@^2.4.3` (peer dependency)
  - `tailwindcss@^3.4.0` (dev dependency for test app)

#### 🔄 Migration Path
Users upgrading to v5.0.0 will need to:
1. Remove jQuery and Select2 dependencies
2. Add Tom Select: `npm install tom-select@^2.4.3`
3. Update CSS imports to use Tom Select styles
4. Update any custom JavaScript that referenced Select2 APIs
5. See `/docs/update-tom-select.md` for detailed migration instructions

#### Previous Changes (v0.5.0 Draft)
- Forked from original repository to @rocket-sensei organization
- Updated package name to `@rocket-sensei/activeadmin-searchable_select` for NPM publishing
- Added GitHub Actions workflow for automated NPM publishing on release
- Fixed all RuboCop linting violations for improved code quality
- Updated CI configuration for better test stability

### Previous Releases

See
[1-8-stable branch](https://github.com/codevise/activeadmin-searchable_select/blob/1-8-stable/CHANGELOG.md)
for previous changes.
