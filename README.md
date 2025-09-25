# ActiveAdmin Tom Select

[![Gem Version](https://badge.fury.io/rb/activeadmin-tom_select.svg)](http://badge.fury.io/rb/activeadmin-tom_select)
[![NPM Version](https://badge.fury.io/js/activeadmin-tom_select.svg)](https://badge.fury.io/js/activeadmin-tom_select)
[![npm](https://img.shields.io/npm/dm/activeadmin-tom_select)](https://www.npmjs.com/package/activeadmin-tom_select)
[![Build Status](https://github.com/rs-pro/activeadmin-tom_select/actions/workflows/ci.yml/badge.svg)](https://github.com/rs-pro/activeadmin-tom_select/actions)

Searchable select boxes (via [Tom Select](https://tom-select.js.org/)) for
ActiveAdmin forms and filters. Extends the ActiveAdmin resource DSL to
allow defining JSON endpoints to fetch options from asynchronously.

**Note:** This gem provides Tom Select integration for ActiveAdmin. It was originally forked from activeadmin-searchable_select but has been completely rewritten to use Tom Select instead of Select2.

## Installation

Add `activeadmin-tom_select` to your Gemfile:

```ruby
   gem 'activeadmin-tom_select'
```

### ActiveAdmin 4.x with Rails 8 (esbuild/importmap/Propshaft)

This gem is optimized for ActiveAdmin 4.x with Rails 8, supporting modern JavaScript bundlers and Propshaft. See the [complete setup guide](docs/guide-update-your-app.md) for detailed instructions.

#### Quick Install with Generator

```bash
# For esbuild (recommended)
rails generate active_admin:searchable_select:install

# For importmap
rails generate active_admin:searchable_select:install --bundler=importmap
```

#### Manual Setup for esbuild

1. Install npm packages:
```bash
npm install activeadmin-tom_select tom-select
```

2. In `app/javascript/active_admin.js`:
```javascript
import "@activeadmin/activeadmin";
import TomSelect from 'tom-select';

// Make Tom Select available globally
window.TomSelect = TomSelect;

// Import and auto-initialize searchable selects
import { setupAutoInit } from 'activeadmin-tom_select';
setupAutoInit();
```

3. Add Tom Select CSS to your ActiveAdmin stylesheet:
```css
@import 'tom-select/dist/css/tom-select.css';
/* Or use CDN: */
@import url('https://cdn.jsdelivr.net/npm/tom-select@2.4.3/dist/css/tom-select.css');
```

### ActiveAdmin 3.x and older

##### Using assets via Sprockets
Import stylesheets and require javascripts:

```scss
// active_admin.css.scss
@import "active_admin/searchable_select";
```

```coffee
// active_admin.js
//= require active_admin/searchable_select
```

##### Using assets via Webpacker

Add to `package.json`:
```json
"dependencies": {
  "activeadmin-tom_select": "^4.1.0"
}
```

In `app/javascript/packs/active_admin.js`:
```javascript
import { setupAutoInit } from 'activeadmin-tom_select';
setupAutoInit();
```

In `app/javascript/stylesheets/active_admin.scss`:
```css
@import 'activeadmin-tom_select/css';
```

## Usage

### Making Select Boxes Searchable

To add search functionality to a select box, use the
`:tom_select` input type:

```ruby
   ActiveAdmin.register Product do
     form do |f|
       f.input(:category, as: :tom_select)
     end
   end
```

This also works for filters:

```ruby
   ActiveAdmin.register Product do
     filter(:category, as: :tom_select)
   end
```

**Note:** The legacy `:searchable_select` input type is still supported for backward compatibility but `:tom_select` is recommended for new code.

By default, you can only select one at a time for a filter. You can
specify a multi-select with:

```ruby
   ActiveAdmin.register Product do
     filter(:category, as: :tom_select, multiple: true)
   end
```

### Fetching Options via Ajax

For large collections, rendering the whole set of options can be to
expensive. Use the `ajax` option to fetch a set of matching options
once the user begins to type:

```ruby

   ActiveAdmin.register Product do
     filter(:category,
            as: :tom_select,
            ajax: true)
   end
```

If the input attribute corresponds to an ActiveAdmin resource, it is
expected to provide the JSON endpoint that provides the options. Use
the `searchable_select_options` method to define the required
collection action:

```ruby
   ActiveAdmin.register Category do
     searchable_select_options(scope: Category.all,
                               text_attribute: :name)
   end
```

By default, `scope` needs to be a Ransack enabled ActiveRecord
collection proxy determining which options are available. The
attribute given by `text_attribute` will be used to get a display name
for each record. Via Ransack, it is also used to filter by search
term. Limiting result set size is handled automatically.

You can customize the display text:

```ruby
   ActiveAdmin.register Category do
     searchable_select_options(scope: Category.all,
                               text_attribute: :name,
                               display_text: ->(record) { "Category: #{record.name}" } )
   end
```

Note that `text_attribute` is still required to perform filtering via
Ransack. You can pass the `filter` option, to specify your own
filtering strategy:

```ruby
   ActiveAdmin.register Category do
     searchable_select_options(scope: Category.all,
                               text_attribute: :name,
                               filter: lambda |term, scope|
                                 scope.ransack(name_cont_all: term.split(' ')).result
                               end)
   end
```

`scope` can also be a lambda which is evaluated in the context of the
collection action defined by the helper:

```ruby
   ActiveAdmin.register Category do
     searchable_select_options(scope: -> { Category.allowed_for(current_user) },
                               text_attribute: :name)
   end
```

If the input attribute is set on the form's object, ajax based
searchable selects will automatically render a single option to ensure
the selected item is displayed correctly even before options have been
loaded asynchronously.

#### Specifying the Options Endpoint Resource

If the resource that provides the options endpoint cannot be guessed
based on the input attribute name, you can pass an object with a
`resource` key as `ajax` option:

```ruby
   ActiveAdmin.register Product do
     form do |f|
       f.input(:additional_category,
               as: :tom_select,
               ajax: { resource: Category })
     end
   end
```

#### Multiple Options Endpoints per Resource

A single ActiveAdmin resource can define multiple options endpoints:

```ruby
   ActiveAdmin.register Category do
     searchable_select_options(name: :favorites,
                               scope: Category.favorites,
                               text_attribute: :name)

     searchable_select_options(name: :recent,
                               scope: Category.recent,
                               text_attribute: :name)
   end
```

To specify which collection to use, pass an object with a
`collection_name` key as `ajax` option:

```ruby
   ActiveAdmin.register Product do
     form do |f|
        f.input(:category,
                as: :tom_select,
                ajax: { collection_name: :favorites })
     end
   end
```

#### Querying Multiple Attributes

ActiveAdmin Searchable Select querying is performed by Ransack. As such, you can
build your query in a way that it can query multiple attributes at once.

```ruby
   ActiveAdmin.register User do
     searchable_select_options(scope: User.all,
                               text_attribute: :username,
                               filter: lambda do |term, scope|
                                 scope.ransack(email_or_username_cont: term).result
                               end)
   end
```

In this example, the `all` scope will query `email OR username`.

You can add the additional payload as dsl option:

```ruby
   ActiveAdmin.register Category do
     searchable_select_options(scope: Category.all,
                               text_attribute: :name,
                               additional_payload: ->(record) { { foo: record.bar } } )
   end
```

response example which uses additional_payload:

```json
{
  "results": [{ "id": "1", "text": "Bicycles", "foo": "Bar" }],
  "pagination": { "more": "false" }
}
```

#### Passing Parameters

You can pass additional parameters to the options endpoint:

```ruby
   ActiveAdmin.register Product do
     form do |f|
        f.input(:category,
                as: :tom_select,
                ajax: {
                  params: {
                    some: 'value'
                  }
                })
     end
   end
```

The lambda passed as `scope` can receive those parameters as first
argument:

```ruby
   ActiveAdmin.register Category do
     searchable_select_options(scope: lambda do |params|
                                 Category.find_all_by_some(params[:some])
                               end,
                               text_attribute: :name)
   end
```

#### Path options for nested resources

Example for the following setup:

```ruby
# Models
class OptionType < ActiveRecord::Base; end

class OptionValue < ActiveRecord::Base
  belongs_to :option_type
end

class Product < ActiveRecord::Base
  belongs_to :option_type
  has_many :variants
end

class Variant < ActiveRecord::Base
  belongs_to :product
  belongs_to :option_value
end

# ActiveAdmin
ActiveAdmin.register(OptionType)

ActiveAdmin.register(Product)

ActiveAdmin.register(OptionValue) do
  belongs_to :option_type
  searchable_select_options(scope: lambda do |params|
                                     OptionValue.where(
                                       option_type_id: params[:option_type_id]
                                     )
                                   end,
                            text_attribute: :value)
end
```

It is possible to pass path parameters for correctly generating URLs for nested resources fetching via `path_params`

```ruby
ActiveAdmin.register(Variant) do
  belongs_to :product

  form do |f|
    ...
    f.input(:option_value,
            as: :tom_select,
            ajax: {
              resource: OptionValue,
              path_params: {
                option_type_id: f.object.product.option_type_id
              }
            })
    ...
  end
end
```

This will generate the path for fetching as `all_options_admin_option_type_option_values(option_type_id: f.object.product.option_type_id)` (e.g. `/admin/option_types/2/option_values/all_options`)

#### Inlining Ajax Options in Feature Tests

When writing UI driven feature specs (i.e. with Capybara),
asynchronous loading of select options can increase test
complexity. `activeadmin-searchable_select` provides an option to
render all available options just like a normal select input while
still exercsing the same code paths including `scope` and
`text_attribute` handling.

For example with RSpec/Capybara, simply set `inline_ajax_options` true
for feature specs:

```ruby
  RSpec.configure do |config|
    config.before(:each) do |example|
      ActiveAdmin::TomSelect.inline_ajax_options = (example.metadata[:type] == :feature)
    end
  end

```

### Passing options to Tom Select

It is possible to pass and define configuration options to Tom Select
via `data-attributes` using nested (subkey) options.

Attributes need to be added to the `input_html` option in the form input.
For example you can tell Tom Select how long to wait after a user
has stopped typing before sending the request:

```ruby
   ...
   f.input(:category,
           as: :tom_select,
           ajax: true,
           input_html: {
             data: {
               'ajax--delay' => 500
             }
           })
   ...
```


## Development

### Running Tests

To run the tests install bundled gems and invoke RSpec:

```bash
$ bundle
$ bundle exec rspec
```

The test suite can be run against different versions of Rails and
Active Admin (see `Appraisals` file):

```bash
$ appraisal install
$ appraisal rspec
```

### Running the Test Application

A full Rails 8 test application is included for manual testing and development:

```bash
# Start the test app
$ cd spec/internal
$ bundle exec rackup

# The app will be available at http://localhost:9292
# Default admin credentials: admin@example.com / password
```

The test app includes:
- Sample models (User, Category, Post, Color) with seed data
- Various admin resources demonstrating different searchable select configurations
- ActiveAdmin with Tailwind CSS integration
- Tom Select with full Tailwind styling

### Building Assets in Test App

```bash
$ cd spec/internal

# Build CSS (Tailwind)
$ bundle exec rake active_admin:build

# Build JavaScript
$ npm run build:js

# Watch for changes during development
$ bundle exec rake active_admin:watch  # CSS
$ npm run watch:js                     # JavaScript
```

### Code Style

Please make sure changes conform with the styleguide:

```bash
$ bundle exec rubocop
```

## Acknowledgements

Based on
[mfairburn/activeadmin-select2](https://github.com/mfairburn/activeadmin-select2).
