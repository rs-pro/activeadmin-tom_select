# ActiveAdmin v4.0.0 Beta Changelog

This document contains all the changes from ActiveAdmin v4.0.0 beta releases.

**Source**: [https://github.com/activeadmin/activeadmin/releases](https://github.com/activeadmin/activeadmin/releases)

---

## v4.0.0.beta20 (2025-01-27)

### Breaking Changes 🚨
- Drop support for Rails 7.0 and 7.1 [#8908](https://github.com/activeadmin/activeadmin/pull/8908)

### Template Updates 📝
- Link to parent menu item [#8225](https://github.com/activeadmin/activeadmin/pull/8225)

### Enhancements ✨
- resource: allow resource_class to be passed as a String [#8848](https://github.com/activeadmin/activeadmin/pull/8848)
- Remove horizontal padding on comments pagination [#8925](https://github.com/activeadmin/activeadmin/pull/8925)
- Add page anchor to comments form view [#8926](https://github.com/activeadmin/activeadmin/pull/8926)
- Fix vertical spacing on has-many forms [#8927](https://github.com/activeadmin/activeadmin/pull/8927)
- Remove no-wrap from table columns [#8928](https://github.com/activeadmin/activeadmin/pull/8928)

### Bug Fixes 🐛
- Restore pointer cursor on eligible buttons [#8878](https://github.com/activeadmin/activeadmin/pull/8878)
- Ignore extra bundler output when DEBUG is set [#8895](https://github.com/activeadmin/activeadmin/pull/8895)

### Other Changes 🛠
- Test supported Rails versions against Ruby 4.0 [#8898](https://github.com/activeadmin/activeadmin/pull/8898)

**Full Changelog**: [v4.0.0.beta19...v4.0.0.beta20](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta19...v4.0.0.beta20)

---

## v4.0.0.beta19 (2024-11-20)

### Breaking Changes 🚨
- Bump tailwind from 3.4.18 to 4.1.17 [#8709](https://github.com/activeadmin/activeadmin/pull/8709)

### Template Updates 📝
- Bump tailwind from 3.4.18 to 4.1.17 [#8709](https://github.com/activeadmin/activeadmin/pull/8709)

### Bug Fixes 🐛
- Remove self-reference to ActiveAdmin node package [#8847](https://github.com/activeadmin/activeadmin/pull/8847)

**Full Changelog**: [v4.0.0.beta18...v4.0.0.beta19](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta18...v4.0.0.beta19)

---

## v4.0.0.beta18 (2024-11-01)

### Enhancements ✨
- Add Rails 8.1.0 compatibility [#8837](https://github.com/activeadmin/activeadmin/pull/8837)

**Full Changelog**: [v4.0.0.beta17...v4.0.0.beta18](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta17...v4.0.0.beta18)

---

## v4.0.0.beta17 (2024-10-21)

### Breaking Changes 🚨
- Preserve custom string labels in AttributesTable headers [#8815](https://github.com/activeadmin/activeadmin/pull/8815)

### Enhancements ✨
- Update French locales [#8770](https://github.com/activeadmin/activeadmin/pull/8770)
- Improve text color contrast [#8535](https://github.com/activeadmin/activeadmin/pull/8535)
- Remove unnecessary base CSS styles [#8803](https://github.com/activeadmin/activeadmin/pull/8803)
- Update dark mode CSS styles [#8809](https://github.com/activeadmin/activeadmin/pull/8809)

**Full Changelog**: [v4.0.0.beta16...v4.0.0.beta17](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta16...v4.0.0.beta17)

---

## v4.0.0.beta16 (2024-07-23)

### Breaking Changes 🚨
- Drop Ruby 3.1 and update dependencies [#8760](https://github.com/activeadmin/activeadmin/pull/8760)
- Remove Tabs component [#8762](https://github.com/activeadmin/activeadmin/pull/8762)

### Template Updates 📝
- Remove `frozen_string_literal` comment from `.arb` templates [#8600](https://github.com/activeadmin/activeadmin/pull/8600)

### Enhancements ✨
- Bump Formtastic to 5.0 and remove legacy code [#8613](https://github.com/activeadmin/activeadmin/pull/8613)
- Add Polish pagination entries translations [#8636](https://github.com/activeadmin/activeadmin/pull/8636)
- Support sortable argument in id_column [#8639](https://github.com/activeadmin/activeadmin/pull/8639)
- Support title for id_column [#8641](https://github.com/activeadmin/activeadmin/pull/8641)
- Update pt-BR translations [#8679](https://github.com/activeadmin/activeadmin/pull/8679)
- Upgrade Flowbite dependency to v3.1.2 [#8692](https://github.com/activeadmin/activeadmin/pull/8692)
- Add some :uk locales [#8732](https://github.com/activeadmin/activeadmin/pull/8732)

### Bug Fixes 🐛
- Fix deprecation warning in Ruby 3.4 [#8593](https://github.com/activeadmin/activeadmin/pull/8593)
- Fix circular require warning in `belongs_to.rb` [#8599](https://github.com/activeadmin/activeadmin/pull/8599)
- Fix pagination truncate translation key [#8678](https://github.com/activeadmin/activeadmin/pull/8678)
- Fix typo in batch_actions locale translation key [#8712](https://github.com/activeadmin/activeadmin/pull/8712)
- Enhance main navbar to improve bouncing on macOS [#8727](https://github.com/activeadmin/activeadmin/pull/8727)
- Remove double bottom border on last table row [#8761](https://github.com/activeadmin/activeadmin/pull/8761)

### Other Changes 🛠
- Normalize i18n locale files [#8715](https://github.com/activeadmin/activeadmin/pull/8715)

**Full Changelog**: [v4.0.0.beta15...v4.0.0.beta16](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta15...v4.0.0.beta16)

---

## v4.0.0.beta15 (2024-12-07)

### Template Updates 📝
- Use ESM in tailwind config template [#8568](https://github.com/activeadmin/activeadmin/pull/8568)

### Enhancements ✨
- Update Korean locale with new translations [#8554](https://github.com/activeadmin/activeadmin/pull/8554)
- Update Arabic locale translations [#8555](https://github.com/activeadmin/activeadmin/pull/8555)
- Fix an issue with Arabic translation [#8557](https://github.com/activeadmin/activeadmin/pull/8557)
- Update Russian locale with new translations [#8558](https://github.com/activeadmin/activeadmin/pull/8558)

**Full Changelog**: [v4.0.0.beta14...v4.0.0.beta15](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta14...v4.0.0.beta15)

---

## v4.0.0.beta14 (2024-11-25)

### Breaking Changes 🚨
- Drop support for Rails 6.1 [#8449](https://github.com/activeadmin/activeadmin/pull/8449)
- Drop Ruby 3.0 compatibility [#8489](https://github.com/activeadmin/activeadmin/pull/8489)

### Enhancements ✨
- Add polish translations for search status [#8487](https://github.com/activeadmin/activeadmin/pull/8487)
- Update zh-TW & ja locale with new v4 keys [#8521](https://github.com/activeadmin/activeadmin/pull/8521)
- Update zh-CN locale with new v4 keys [#8546](https://github.com/activeadmin/activeadmin/pull/8546)
- Improve v3 docs regarding compatibility with vite_rails [#8549](https://github.com/activeadmin/activeadmin/pull/8549)
- Remove redundant safe navigation operator [#8528](https://github.com/activeadmin/activeadmin/pull/8528)
- Use safe navigation for `pundit_default_policy` [#8530](https://github.com/activeadmin/activeadmin/pull/8530)
- Use safe navigation operator in layout helper [#8533](https://github.com/activeadmin/activeadmin/pull/8533)

### Bug Fixes 🐛
- run update_resource inside a transaction to avoid autosaving relationships through assign_attributes when the record is invalid [#7437](https://github.com/activeadmin/activeadmin/pull/7437)
- Fix attributes passed to form has_many not being set on new record form items [#8550](https://github.com/activeadmin/activeadmin/pull/8550)
- Convert plugin.js to ESM because package.json has type set to module [#8536](https://github.com/activeadmin/activeadmin/pull/8536)

### Other Changes 🛠
- Migrate docs to VitePress [#8194](https://github.com/activeadmin/activeadmin/pull/8194)

**Full Changelog**: [v4.0.0.beta13...v4.0.0.beta14](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta13...v4.0.0.beta14)

---

## v4.0.0.beta13 (2024-09-24)

### Enhancements ✨
- Add polish translations for v4 keys [#8481](https://github.com/activeadmin/activeadmin/pull/8481)
- Add spanish translations for v4 keys [#8483](https://github.com/activeadmin/activeadmin/pull/8483)
- Prefer `require_relative` for internal requires [#8482](https://github.com/activeadmin/activeadmin/pull/8482)

**Full Changelog**: [v4.0.0.beta12...v4.0.0.beta13](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta12...v4.0.0.beta13)

---

## v4.0.0.beta12 (2024-09-15)

### Enhancements ✨
- Bump `inherited_resources` requirement to `~> 2.0` [#8477](https://github.com/activeadmin/activeadmin/pull/8477)

**Full Changelog**: [v4.0.0.beta11...v4.0.0.beta12](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta11...v4.0.0.beta12)

---

## v4.0.0.beta11 (2024-08-31)

### Enhancements ✨
- Unify specifying label in attributes_table component [#8458](https://github.com/activeadmin/activeadmin/pull/8458)
- Optimize count query for `pagination_total: false` option [#6911](https://github.com/activeadmin/activeadmin/pull/6911)
- Use attribute_types instead of columns_hash to determine type [#8457](https://github.com/activeadmin/activeadmin/pull/8457)

### Bug Fixes 🐛
- Use consistent text-like inputs selector list for CSS styles [#8456](https://github.com/activeadmin/activeadmin/pull/8456)

**Full Changelog**: [v4.0.0.beta10...v4.0.0.beta11](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta10...v4.0.0.beta11)

---

## v4.0.0.beta10 (2024-08-24)

### Template Updates 📝
- Add host app's layouts/active_admin to tailwind config [#8430](https://github.com/activeadmin/activeadmin/pull/8430)

### Enhancements ✨
- Support async_count for scopes [#8394](https://github.com/activeadmin/activeadmin/pull/8394)
- Add tbody_html and row_html options to TableFor and IndexAsTable [#8423](https://github.com/activeadmin/activeadmin/pull/8423)

### Bug Fixes 🐛
- Improve form f.inputs attributes rendering [#8439](https://github.com/activeadmin/activeadmin/pull/8439), [#8448](https://github.com/activeadmin/activeadmin/pull/8448)
- Fix batch action with partial and no confirm doesn't submit the form on click [#8442](https://github.com/activeadmin/activeadmin/pull/8442)

**Full Changelog**: [v4.0.0.beta9...v4.0.0.beta10](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta9...v4.0.0.beta10)

---

## v4.0.0.beta9 (2024-08-04)

### Template Updates 📝
- Add accessible names for navigation buttons [#8338](https://github.com/activeadmin/activeadmin/pull/8338)

### Enhancements ✨
- Better implementation of counter-cache-column check [#8411](https://github.com/activeadmin/activeadmin/pull/8411)

### Other Changes 🛠
- Fix url redirects in documentation [#8407](https://github.com/activeadmin/activeadmin/pull/8407)

**Full Changelog**: [v4.0.0.beta8...v4.0.0.beta9](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta8...v4.0.0.beta9)

---

## v4.0.0.beta8 (2024-07-27)

### Enhancements ✨
- Update Catalan translation [#8356](https://github.com/activeadmin/activeadmin/pull/8356)
- Allow batch actions without a confirmation dialog [#8389](https://github.com/activeadmin/activeadmin/pull/8389)
- Fix styles for select[multiple] form controls [#8406](https://github.com/activeadmin/activeadmin/pull/8406)

**Full Changelog**: [v4.0.0.beta7...v4.0.0.beta8](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta7...v4.0.0.beta8)

---

## v4.0.0.beta7 (2024-05-31)

### Enhancements ✨
- Update de locale with new v4 keys [#8325](https://github.com/activeadmin/activeadmin/pull/8325)
- Remove de-CH locale [#8326](https://github.com/activeadmin/activeadmin/pull/8326)

### Security Fixes 🔒
- Fix potential XSS issue when rendering form legends [#8348](https://github.com/activeadmin/activeadmin/pull/8348)

**Full Changelog**: [v4.0.0.beta6...v4.0.0.beta7](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta6...v4.0.0.beta7)

---

## v4.0.0.beta6 (2024-05-03)

### Breaking Changes 🚨
- Drop Ruby 2.7 support [#8259](https://github.com/activeadmin/activeadmin/pull/8259)

### Template Updates 📝
- Use Tailwind's darkMode selector strategy [#8264](https://github.com/activeadmin/activeadmin/pull/8264)

### Enhancements ✨
- Update zh-CN locale with new v4 keys [#8284](https://github.com/activeadmin/activeadmin/pull/8284)
- Update zh-TW locale with new v4 keys [#8297](https://github.com/activeadmin/activeadmin/pull/8297)

### Bug Fixes 🐛
- Add csv dependency to fix Ruby 3.3 warning [#8303](https://github.com/activeadmin/activeadmin/pull/8303)

**Full Changelog**: [v4.0.0.beta5...v4.0.0.beta6](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta5...v4.0.0.beta6)

---

## v4.0.0.beta5 (2024-02-14)

### Enhancements ✨
- Improve Italian translation [#8235](https://github.com/activeadmin/activeadmin/pull/8235)
- Bump flowbite to v2.3.0 [#8257](https://github.com/activeadmin/activeadmin/pull/8257)

### Bug Fixes 🐛
- Use an anchor for tabs component toggle [#8242](https://github.com/activeadmin/activeadmin/pull/8242)

**Full Changelog**: [v4.0.0.beta4...v4.0.0.beta5](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta4...v4.0.0.beta5)

---

## v4.0.0.beta4 (2024-01-17)

### Template Updates 📝
- Move pagination translations to active_admin scope [#8218](https://github.com/activeadmin/activeadmin/pull/8218)

### Enhancements ✨
- Vendor rails-ujs ESM JS [#8217](https://github.com/activeadmin/activeadmin/pull/8217)
- Include vendor JS files in NPM package [#8221](https://github.com/activeadmin/activeadmin/pull/8221)
- Remove i18n-tasks.yml from gem release [#8227](https://github.com/activeadmin/activeadmin/pull/8227)
- Make importmap-rails optional [#8228](https://github.com/activeadmin/activeadmin/pull/8228)
- Exclude primary key from generated resource [#8232](https://github.com/activeadmin/activeadmin/pull/8232)
- Make NPM package compatible with tools like vite_rails [#8234](https://github.com/activeadmin/activeadmin/pull/8234)

### Bug Fixes 🐛
- Ensure form presenter is applied on create/update actions [#8238](https://github.com/activeadmin/activeadmin/pull/8238)

**Full Changelog**: [v4.0.0.beta3...v4.0.0.beta4](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta3...v4.0.0.beta4)

---

## v4.0.0.beta3 (2024-01-06)

- Include additional files in gem release [#8212](https://github.com/activeadmin/activeadmin/pull/8212)

**Full Changelog**: [v4.0.0.beta2...v4.0.0.beta3](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta2...v4.0.0.beta3)

---

## v4.0.0.beta2 (2024-01-06)

- Include vendor directory in gem release [#8211](https://github.com/activeadmin/activeadmin/pull/8211)

**Full Changelog**: [v4.0.0.beta1...v4.0.0.beta2](https://github.com/activeadmin/activeadmin/compare/v4.0.0.beta1...v4.0.0.beta2)

---

## v4.0.0.beta1 (2024-01-06)

**First beta release of ActiveAdmin v4!**

This release represents a complete redesign using TailwindCSS with **mobile web, dark mode and RTL support** and a default, **customizable theme through partials**.

### Key Features
- **TailwindCSS**: Complete migration to TailwindCSS
- **Mobile Support**: Fully responsive design
- **Dark Mode**: Built-in dark mode support
- **RTL Support**: Right-to-left language support
- **ESM JavaScript**: Modern ES modules
- **importmap-rails**: Uses importmap-rails for JS assets
- **Customizable Theme**: Theme customization through partials

### Breaking Changes 🚨
- Requires `cssbundling-rails` and `importmap-rails`
- Removed all SCSS files (sassc-rails dependency removed)
- Complete UI/UX redesign

### Major Changes
- Prep Tailwind CSS migration (multiple PRs: #8035, #8036, #8037, #8116, #8122, #8139, #8155, #8170)
- Remove old, since replaced JS [#8040](https://github.com/activeadmin/activeadmin/pull/8040)
- Replace html/assets related configs with simple partials [#8156](https://github.com/activeadmin/activeadmin/pull/8156)
- Remove sassc-rails and all SCSS files [#8157](https://github.com/activeadmin/activeadmin/pull/8157)
- Extract headers, menu and sidebar components to partials [#8162](https://github.com/activeadmin/activeadmin/pull/8162)
- Use ES format for JS [#8171](https://github.com/activeadmin/activeadmin/pull/8171)
- Extract layout and pages to partials [#8172](https://github.com/activeadmin/activeadmin/pull/8172)
- Use importmap-rails for JS assets [#8186](https://github.com/activeadmin/activeadmin/pull/8186)
- Move kaminari templates to active_admin folder [#8190](https://github.com/activeadmin/activeadmin/pull/8190)
- Improve RTL support all around [#8196](https://github.com/activeadmin/activeadmin/pull/8196)
- Migrate view helpers to app/helpers path [#8202](https://github.com/activeadmin/activeadmin/pull/8202)

### Enhancements ✨
- Provide detail in DB statement timeout error for filters [#8117](https://github.com/activeadmin/activeadmin/pull/8117)
- Use active_admin_authorization as Ransack auth_object option [#8143](https://github.com/activeadmin/activeadmin/pull/8143)
- Update FR locales [#8193](https://github.com/activeadmin/activeadmin/pull/8193)
- Update nl.yml for v4 [#8195](https://github.com/activeadmin/activeadmin/pull/8195)

### Other Changes 🛠
- Introduce RuboCop Performance [#8024](https://github.com/activeadmin/activeadmin/pull/8024)
- Remove multiline ternary operator [#8034](https://github.com/activeadmin/activeadmin/pull/8034)
- Prefer `match?` over `=~` to avoid MatchData [#8138](https://github.com/activeadmin/activeadmin/pull/8138)

**Full Changelog**: [v3.2.0...v4.0.0.beta1](https://github.com/activeadmin/activeadmin/compare/v3.2.0...v4.0.0.beta1)

---

## Summary

**Minimum Requirements (as of v4.0.0.beta20):**
- Rails 7.2+
- Ruby 3.2+
- cssbundling-rails
- importmap-rails (optional as of beta4)

**Key Migration Path:**
The v4.0.0 beta series represents a complete redesign of ActiveAdmin using TailwindCSS. The migration requires:
1. Installing `cssbundling-rails` and configuring TailwindCSS
2. Installing `importmap-rails` (optional since beta4)
3. Running the assets generator
4. Updating custom CSS/JS from the old SCSS/jQuery patterns
5. Reviewing the [Upgrading guide](https://github.com/activeadmin/activeadmin/blob/master/UPGRADING.md)

See [demo app](https://github.com/activeadmin/demo.activeadmin.info) for a working example.
