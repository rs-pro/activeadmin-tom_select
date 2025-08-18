import $ from 'jquery';
import select2 from 'select2';

// Explicitly attach select2 to jQuery
// This is required for esbuild/webpack bundlers
select2($);

// Also ensure jQuery is available globally for ActiveAdmin
window.$ = window.jQuery = $;

import './searchable_select/init';
