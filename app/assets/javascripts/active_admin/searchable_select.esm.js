// ES Module version for ActiveAdmin 4+ with esbuild/importmap
import $ from 'jquery';
import select2 from 'select2';
import 'select2/dist/css/select2.css';

// Initialize select2 with jQuery
// This is critical for production builds where select2 doesn't auto-attach
select2($);

// Ensure jQuery is globally available (required by ActiveAdmin)
if (!window.$) {
  window.$ = $;
}
if (!window.jQuery) {
  window.jQuery = $;
}

function initSearchableSelects(inputs, extra) {
  // Verify select2 is loaded
  if (!$.fn.select2) {
    console.error('ActiveAdmin Searchable Select: select2 plugin not found on jQuery');
    return;
  }
  
  inputs.each(function() {
    const item = $(this);
    
    // Skip if already initialized
    if (item.hasClass('select2-hidden-accessible')) {
      return;
    }

    // reading from data allows <input data-searchable_select='{"tags": ['some']}'>
    // to be passed to select2
    const options = $.extend(extra || {}, item.data('searchableSelect'));
    const url = item.data('ajaxUrl');

    if (url) {
      $.extend(options, {
        ajax: {
          url: url,
          dataType: 'json',
          delay: 250,
          
          data: function (params) {
            return {
              term: params.term,
              page: params.page ? params.page - 1 : undefined
            };
          },
          
          processResults: function(data, params) {
            params.page = params.page || 1;
            return data;
          },
          
          cache: true
        },
        
        minimumInputLength: 0,
        allowClear: true
      });
    }

    try {
      item.select2(options);
    } catch (e) {
      console.error('Failed to initialize select2:', e);
    }
  });
}

// Initialize on DOM ready
$(function() {
  initSearchableSelects($(".searchable-select-input"));
});

// Support Turbo (Rails 7) and Turbolinks (older Rails)
document.addEventListener('turbo:load', function() {
  initSearchableSelects($(".searchable-select-input"), {placeholder: ""});
});

document.addEventListener('turbolinks:load', function() {
  initSearchableSelects($(".searchable-select-input"), {placeholder: ""});
});

// Support ActiveAdmin has_many fields
$(document).on('has_many_add:after', '.has_many_container', function(e, fieldset) {
  initSearchableSelects(fieldset.find('.searchable-select-input'));
});

// Export for potential direct usage
export { initSearchableSelects };