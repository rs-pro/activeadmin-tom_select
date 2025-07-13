# Upgrading Guide

## Upgrading from 1.x to 2.0

Version 2.0 adds support for ActiveAdmin 4.0 while maintaining backward compatibility with earlier versions.

### Key Changes

1. **JavaScript Module Support**: The gem now supports ES modules for use with modern bundlers like esbuild or importmap.

2. **Tailwind CSS Support**: For ActiveAdmin 4.0, the gem includes Tailwind-compatible styles.

3. **Importmap Support**: Rails 7 applications using importmap will automatically have the JavaScript pinned.

### For ActiveAdmin 4.0 Users

If you're using ActiveAdmin 4.0 with importmap, the JavaScript will be automatically configured. You just need to ensure select2 is available:

```javascript
// app/javascript/application.js
import select2 from 'select2/dist/js/select2'
select2($);

import "active_admin_searchable_select"
```

For CSS, if using Tailwind with ActiveAdmin 4:

```css
/* app/assets/stylesheets/active_admin.css */
@import "active_admin/searchable_select_tailwind.css";
```

### For ActiveAdmin 1.x - 3.x Users

The existing Sprockets-based setup continues to work:

```scss
// active_admin.scss
@import "active_admin/searchable_select";
```

```javascript
// active_admin.js
//= require active_admin/searchable_select
```

### Testing

The gem now includes comprehensive tests including demo app generation. To run tests with browser testing:

```bash
RUN_BROWSER_TESTS=1 bundle exec rspec
```