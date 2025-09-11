# Tailwind CSS v3 to v4 Upgrade Guide - Enhanced Edition

This enhanced guide focuses on migrating from Tailwind CSS v3 to v4, with special attention to form controls, select elements, and component styling.

## Table of Contents
1. [Quick Start](#quick-start)
2. [Core Breaking Changes](#core-breaking-changes)
3. [Form and Input Styling Changes](#form-and-input-styling-changes)
4. [Select Element Changes](#select-element-changes)
5. [Component Migration Guide](#component-migration-guide)
6. [Tom Select & Custom Selects](#tom-select--custom-selects)
7. [Migration Checklist](#migration-checklist)

## Quick Start

### Automated Upgrade
```bash
# Use the official upgrade tool (requires Node.js 20+)
$ npx @tailwindcss/upgrade
```

### Manual Installation

#### PostCSS Setup
```js
// postcss.config.mjs
export default {
  plugins: {
    // Remove these v3 plugins
    // "postcss-import": {},
    // tailwindcss: {},
    // autoprefixer: {},
    
    // Add v4 plugin
    "@tailwindcss/postcss": {},
  },
};
```

#### Vite Setup (Recommended)
```ts
// vite.config.ts
import { defineConfig } from "vite";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [tailwindcss()],
});
```

#### CSS Import Change
```css
/* v3 */
@tailwind base;
@tailwind components;
@tailwind utilities;

/* v4 */
@import "tailwindcss";
```

## Core Breaking Changes

### Browser Requirements
- **Minimum versions**: Safari 16.4+, Chrome 111+, Firefox 128+
- Uses modern CSS features: `@property`, `color-mix()`, cascade layers
- No fallback for older browsers

### Configuration Migration

#### v3: JavaScript Config
```js
// tailwind.config.js (v3)
module.exports = {
  content: ['./src/**/*.{html,js}'],
  theme: {
    extend: {
      colors: {
        brand: '#1a73e8',
      },
    },
  },
  plugins: [require('@tailwindcss/forms')],
}
```

#### v4: CSS-First Config
```css
/* app.css (v4) */
@import "tailwindcss";

@theme {
  --color-brand: #1a73e8;
  --font-display: "Inter", "sans-serif";
  --breakpoint-3xl: 120rem;
}

/* Automatic content detection - no config needed! */
```

### Renamed Utilities

| v3 | v4 | Notes |
|---|---|-------|
| `shadow-sm` | `shadow-xs` | |
| `shadow` | `shadow-sm` | |
| `rounded-sm` | `rounded-xs` | |
| `rounded` | `rounded-sm` | |
| `outline-none` | `outline-hidden` | Invisible outline for a11y |
| `ring` | `ring-3` | Default width changed |

## Form and Input Styling Changes

### Default Border Colors
```css
/* v3: gray-200 by default */
.border { border-color: rgb(229 231 235); }

/* v4: currentColor by default */
.border { border-color: currentColor; }

/* Fix: Always specify border color */
<input class="border border-gray-200" />

/* Or add global override */
@layer base {
  *,
  ::after,
  ::before,
  ::backdrop,
  ::file-selector-button {
    border-color: var(--color-gray-200, currentColor);
  }
}
```

### Placeholder Colors
```css
/* v3: gray-400 by default */
input::placeholder { color: rgb(156 163 175); }

/* v4: 50% opacity of text color */
input::placeholder { color: color-mix(in srgb, currentColor 50%, transparent); }

/* Restore v3 behavior if needed */
@layer base {
  input::placeholder,
  textarea::placeholder {
    color: var(--color-gray-400);
  }
}
```

### Button Cursor Changes
```css
/* v3: pointer cursor */
button { cursor: pointer; }

/* v4: default cursor (browser default) */
button { cursor: default; }

/* Restore pointer cursor */
@layer base {
  button:not(:disabled),
  [role="button"]:not(:disabled) {
    cursor: pointer;
  }
}
```

### New Form Utilities in v4

#### Field Sizing
```html
<!-- Auto-resize textareas without JavaScript -->
<textarea class="field-sizing-content">
  Content grows with text
</textarea>

<!-- Fixed size (default behavior) -->
<textarea class="field-sizing-fixed w-full">
  Fixed width textarea
</textarea>
```

#### Accent Color
```html
<!-- Custom checkbox/radio colors -->
<input type="checkbox" class="accent-blue-500" />
<input type="radio" class="accent-purple-500" />

<!-- With opacity modifier -->
<input type="checkbox" class="accent-green-500/75" />
```

## Select Element Changes

### Native Select Styling

#### v3 Approach
```html
<!-- v3: Required forms plugin or custom styles -->
<select class="form-select rounded-md border-gray-300">
  <option>Option 1</option>
</select>
```

#### v4 Approach
```html
<!-- v4: Style with utilities directly -->
<select class="rounded-sm border border-gray-300 bg-white px-3 py-2">
  <option>Option 1</option>
</select>

<!-- Remove default appearance for custom styling -->
<div class="relative">
  <select class="appearance-none rounded-sm border border-gray-300 bg-white pl-3 pr-10 py-2">
    <option>Option 1</option>
  </select>
  <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-2">
    <svg class="h-5 w-5 text-gray-400"><!-- chevron icon --></svg>
  </div>
</div>
```

### Forms Plugin Changes

The `@tailwindcss/forms` plugin approach has changed in v4:

```css
/* v3: Auto-applied with plugin */
/* @tailwindcss/forms would style all inputs automatically */

/* v4: Explicit utility classes */
/* More control, less magic */
```

## Component Migration Guide

### Card/Panel Component

#### v3
```html
<div class="shadow rounded bg-white p-4">
  <h3 class="text-lg font-semibold">Card Title</h3>
  <p class="text-gray-600">Card content</p>
</div>
```

#### v4
```html
<div class="shadow-sm rounded-sm bg-white p-4">
  <h3 class="text-lg font-semibold">Card Title</h3>
  <p class="text-gray-600">Card content</p>
</div>
```

### Form Component

#### v3
```html
<form class="space-y-4">
  <div>
    <label class="block text-sm font-medium text-gray-700">
      Name
    </label>
    <input type="text" 
           class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
  </div>
  <button class="rounded bg-blue-500 px-4 py-2 text-white hover:bg-blue-600">
    Submit
  </button>
</form>
```

#### v4
```html
<form class="flex flex-col gap-4">
  <div>
    <label class="block text-sm font-medium text-gray-700">
      Name
    </label>
    <input type="text" 
           class="mt-1 block w-full rounded-sm border border-gray-300 shadow-xs focus:border-indigo-500 focus:ring-3 focus:ring-indigo-500">
  </div>
  <button class="rounded-sm bg-blue-500 px-4 py-2 text-white hover:bg-blue-600 cursor-pointer">
    Submit
  </button>
</form>
```

## Tom Select & Custom Selects

### Tom Select with Tailwind v4

```css
/* tom-select-tailwind.css for v4 */
@layer components {
  .ts-wrapper {
    @apply relative;
  }
  
  .ts-control {
    @apply flex flex-wrap items-center rounded-sm border border-gray-300 bg-white px-3 py-2;
    @apply focus-within:border-blue-500 focus-within:ring-3 focus-within:ring-blue-500;
  }
  
  .ts-control input {
    @apply flex-1 border-0 bg-transparent p-0 outline-hidden;
  }
  
  .ts-dropdown {
    @apply absolute z-50 mt-1 w-full rounded-sm border border-gray-200 bg-white shadow-sm;
  }
  
  .ts-dropdown .option {
    @apply cursor-pointer px-3 py-2 hover:bg-gray-100;
  }
  
  .ts-dropdown .option.active {
    @apply bg-blue-50 text-blue-700;
  }
}
```

### Select2 to Tom Select Migration

| Select2 Class | Tom Select Class | Purpose |
|--------------|------------------|---------|
| `.select2-container` | `.ts-wrapper` | Main container |
| `.select2-selection` | `.ts-control` | Selected items display |
| `.select2-dropdown` | `.ts-dropdown` | Dropdown container |
| `.select2-results__option` | `.ts-dropdown .option` | Dropdown options |
| `.select2-search__field` | `.ts-control input` | Search input |

## Migration Checklist

### Pre-Migration
- [ ] Verify Node.js 20+ is installed
- [ ] Check browser support requirements
- [ ] Backup current configuration
- [ ] Review custom components for breaking changes

### Core Changes
- [ ] Run upgrade tool or manually update dependencies
- [ ] Convert `@tailwind` directives to `@import "tailwindcss"`
- [ ] Migrate JavaScript config to CSS `@theme` block
- [ ] Update PostCSS or switch to Vite plugin

### Utility Updates
- [ ] Replace `shadow` → `shadow-sm`, `shadow-sm` → `shadow-xs`
- [ ] Replace `rounded` → `rounded-sm`, `rounded-sm` → `rounded-xs`
- [ ] Replace `outline-none` → `outline-hidden`
- [ ] Replace `ring` → `ring-3`
- [ ] Update `space-y-*` to `flex flex-col gap-*` where needed

### Form Styling
- [ ] Add explicit border colors to all border utilities
- [ ] Review placeholder text colors
- [ ] Add `cursor-pointer` to buttons if needed
- [ ] Update select elements with explicit styles
- [ ] Test form components with new utilities

### Component Libraries
- [ ] Update Tom Select styles for v4 utilities
- [ ] Migrate Select2 to Tom Select if applicable
- [ ] Test all custom dropdowns and selects
- [ ] Verify third-party component compatibility

### Testing
- [ ] Test in all target browsers
- [ ] Verify responsive designs work correctly
- [ ] Check dark mode if implemented
- [ ] Validate accessibility features
- [ ] Run visual regression tests

### Post-Migration
- [ ] Update documentation
- [ ] Train team on new v4 patterns
- [ ] Monitor for issues in production
- [ ] Document any custom workarounds

## Additional Resources

- [Official Tailwind CSS v4.0 Blog Post](https://tailwindcss.com/blog/tailwindcss-v4)
- [Official Upgrade Guide](https://tailwindcss.com/docs/upgrade-guide)
- [v4.0 Release Notes](https://github.com/tailwindlabs/tailwindcss/releases/tag/v4.0.0)
- [Tom Select Documentation](https://tom-select.js.org/)
- [Modern CSS Features Used in v4](https://developer.mozilla.org/en-US/docs/Web/CSS)

## Common Gotchas

1. **CSS Variables in Media Queries**: The `theme()` function now uses CSS variable names
   ```css
   /* v3 */
   @media (min-width: theme(screens.lg)) { }
   
   /* v4 */
   @media (min-width: theme(--breakpoint-lg)) { }
   ```

2. **Gradient Preservation**: Gradients now preserve all stops when overridden
   ```html
   <!-- v3: to-yellow-400 becomes transparent in dark mode -->
   <div class="bg-gradient-to-r from-red-500 to-yellow-400 dark:from-blue-500"></div>
   
   <!-- v4: Explicitly reset with via-none -->
   <div class="bg-linear-to-r from-red-500 via-orange-400 to-yellow-400 dark:via-none dark:from-blue-500 dark:to-teal-400"></div>
   ```

3. **Hover on Touch Devices**: `hover:` now only applies when device supports hover
   ```css
   /* v4: Add custom variant for old behavior */
   @custom-variant hover (&:hover);
   ```

4. **Dynamic Values**: Many utilities now accept any value without configuration
   ```html
   <!-- v3: Required extending config -->
   <div class="grid-cols-[arbitrary]">
   
   <!-- v4: Works out of the box -->
   <div class="grid-cols-15">
   <div class="mt-17">
   <div class="w-29">
   ```

## Summary

Tailwind CSS v4 brings significant improvements in performance, developer experience, and modern CSS support. While there are breaking changes, the upgrade tool handles most migrations automatically. The key changes for forms and selects are:

1. More explicit styling requirements (no magic defaults)
2. Better performance with native CSS features
3. Improved customization through CSS variables
4. Enhanced form utilities like `field-sizing` and `accent-color`
5. Simpler configuration without JavaScript

The migration effort is worth it for the performance gains (5x faster builds, 100x faster incremental builds) and the improved developer experience with automatic content detection and CSS-first configuration.