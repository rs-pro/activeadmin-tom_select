# ActiveAdmin Searchable Select Gem Fix Guide

## The Problem

The `activeadmin-searchable_select` gem is completely broken with ActiveAdmin 4.0.0.beta16. Users get:
```
Formtastic::UnknownInputError: Unable to find input class SearchableSelectInput
```

**Users should NOT need any initializer for basic functionality!**

## Our Failed Attempts to Fix It

We tried to fix this gem for ActiveAdmin 4 and **failed miserably**. Here's what we attempted and why it didn't work:

### Failed Attempt 1: Manual Registration in Initializer
```ruby
# This shouldn't be necessary but we tried it anyway
Rails.application.config.after_initialize do
  if defined?(ActiveAdmin) && defined?(Formtastic)
    require "activeadmin/searchable_select"
    require "activeadmin/inputs/searchable_select_input"
    require "activeadmin/inputs/filters/searchable_select_input"
    
    # This is stupid but necessary because the gem doesn't do it
    Formtastic::Inputs::SearchableSelectInput = ActiveAdmin::Inputs::SearchableSelectInput
  end
end
```
**Result**: Partially works but users shouldn't need this hack!

### Failed Attempt 2: Complex Autoloading
```ruby
# We tried being clever with autoloading - DON'T DO THIS
module ActiveAdmin
  module Inputs
    autoload :SearchableSelectInput, 'activeadmin/inputs/searchable_select_input'
    module Filters
      autoload :SearchableSelectInput, 'activeadmin/inputs/filters/searchable_select_input'
    end
  end
end
```
**Result**: Doesn't work, autoload timing is unpredictable

### Failed Attempt 3: Monkey-patching Formtastic
```ruby
# Tried to force Formtastic to find the inputs - TERRIBLE IDEA
Formtastic::FormBuilder.input_namespaces ||= []
Formtastic::FormBuilder.input_namespaces << ActiveAdmin::Inputs
```
**Result**: Breaks other things, order-dependent mess

## The Core Issues We Found

1. **The gem never registers its inputs with Formtastic** - This is the fundamental bug
2. **Load order is completely broken** - The gem loads before/after ActiveAdmin unpredictably
3. **No proper Rails engine hooks** - The gem doesn't use Rails initializer system correctly
4. **Assumes Formtastic will magically find the inputs** - It won't!
5. **The gem's engine.rb does nothing useful** - It's basically empty

## What the Gem MUST Fix

### Fix 1: Proper Engine with Initializers

**File: `lib/activeadmin/searchable_select/engine.rb`**

```ruby
module ActiveAdmin
  module SearchableSelect
    class Engine < ::Rails::Engine
      isolate_namespace ActiveAdmin::SearchableSelect
      
      # THIS IS THE CRITICAL FIX - USE PROPER INITIALIZER HOOKS!
      initializer "activeadmin_searchable_select.register_inputs", 
                  before: "active_admin.load_app_dependencies" do |app|
        # Wait for Rails to be ready
        app.config.to_prepare do
          # Load our input classes FIRST
          require "activeadmin/inputs/searchable_select_input"
          require "activeadmin/inputs/filters/searchable_select_input"
          
          # REGISTER WITH FORMTASTIC - THIS IS MANDATORY!
          if defined?(::Formtastic::Inputs)
            ::Formtastic::Inputs::SearchableSelectInput = ::ActiveAdmin::Inputs::SearchableSelectInput
          else
            # If Formtastic isn't loaded yet, wait for it
            ActiveSupport.on_load(:formtastic) do
              ::Formtastic::Inputs::SearchableSelectInput = ::ActiveAdmin::Inputs::SearchableSelectInput
            end
          end
        end
      end
      
      # Register DSL extensions AFTER ActiveAdmin loads
      initializer "activeadmin_searchable_select.register_extensions", 
                  after: "active_admin.setup" do |app|
        if defined?(::ActiveAdmin)
          ::ActiveAdmin::ResourceDSL.include(ResourceDslExtension)
          ::ActiveAdmin::Resource.include(ResourceExtension)
        end
      end
    end
  end
end
```

### Fix 2: Self-Registering Input Classes

**File: `lib/activeadmin/inputs/searchable_select_input.rb`**

```ruby
module ActiveAdmin
  module Inputs
    class SearchableSelectInput < Formtastic::Inputs::SelectInput
      # ... existing implementation ...
    end
  end
end

# CRITICAL: Self-register immediately when loaded
# Don't wait for some magic to happen - IT WON'T!
if defined?(::Formtastic::Inputs)
  ::Formtastic::Inputs::SearchableSelectInput = ::ActiveAdmin::Inputs::SearchableSelectInput
else
  # Formtastic not loaded yet? Set up a hook
  ActiveSupport.on_load(:active_admin) do
    if defined?(::Formtastic::Inputs)
      ::Formtastic::Inputs::SearchableSelectInput = ::ActiveAdmin::Inputs::SearchableSelectInput
    end
  end
end
```

### Fix 3: Stop Assuming Magic Will Happen

The gem currently assumes:
- Formtastic will somehow find `ActiveAdmin::Inputs::SearchableSelectInput` - **IT WON'T**
- Rails autoloading will load everything in the right order - **IT WON'T**
- ActiveAdmin will do the registration for you - **IT WON'T**
- Users will write initializers to fix your gem - **THEY SHOULDN'T HAVE TO**

## Why This Is So Broken

1. **Formtastic only looks in `Formtastic::Inputs` namespace** - The gem's inputs are in `ActiveAdmin::Inputs`
2. **No registration mechanism** - The gem creates the class but never tells Formtastic about it
3. **Wrong assumptions about Rails loading** - Modern Rails with Zeitwerk doesn't work like Rails 4
4. **No test coverage for ActiveAdmin 4** - The gem was never properly tested with AA4

## The Harsh Reality

This gem needs a complete rewrite for ActiveAdmin 4. The current architecture is fundamentally incompatible with how ActiveAdmin 4 and Formtastic 4 work together.

Until then, users have two options:
1. Add the ugly workaround initializer (see above)
2. Stop using this gem and use regular selects

## What We Gave Up On

After hours of trying, we gave up on making this gem work properly without user intervention. The gem's architecture is too broken. It needs:

- Complete rewrite of the engine
- Proper initializer hooks
- Self-registering inputs
- Test coverage with ActiveAdmin 4
- Documentation that admits the gem is broken

**Bottom line**: This gem is broken for ActiveAdmin 4 and the maintainers need to fix the fundamental registration issue, not just patch around it.