// Importmap-compatible version for Rails 7+ with pinned imports
// This file can be used with importmap-rails without a build step

(function() {
  'use strict';
  
  // Wait for dependencies
  function waitForDependencies(callback) {
    let attempts = 0;
    const maxAttempts = 50;
    
    function check() {
      attempts++;
      
      if (typeof jQuery !== 'undefined' && jQuery.fn && typeof jQuery.fn.select2 !== 'undefined') {
        callback();
      } else if (attempts < maxAttempts) {
        setTimeout(check, 100);
      } else {
        console.error('[ActiveAdmin Searchable Select] Dependencies not loaded after 5 seconds. jQuery:', typeof jQuery !== 'undefined', 'Select2:', typeof jQuery !== 'undefined' && jQuery.fn && typeof jQuery.fn.select2 !== 'undefined');
      }
    }
    
    check();
  }
  
  function initSearchableSelects(inputs, extra) {
    const $ = jQuery;
    
    // Final check
    if (!$.fn.select2) {
      console.error('[ActiveAdmin Searchable Select] Select2 not available on jQuery');
      return;
    }
    
    inputs.each(function() {
      const item = $(this);
      
      // Skip if already initialized
      if (item.hasClass('select2-hidden-accessible')) {
        return;
      }

      // Merge options
      const options = $.extend({}, extra || {}, item.data('searchableSelect') || {});
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
          allowClear: true,
          placeholder: options.placeholder || ''
        });
      }

      try {
        item.select2(options);
      } catch (e) {
        console.error('[ActiveAdmin Searchable Select] Failed to initialize:', e);
      }
    });
  }
  
  // Initialize when dependencies are ready
  waitForDependencies(function() {
    const $ = jQuery;
    
    // Initial load
    $(function() {
      initSearchableSelects($('.searchable-select-input'));
    });
    
    // Turbo support (Rails 7+)
    document.addEventListener('turbo:load', function() {
      initSearchableSelects($('.searchable-select-input'), {placeholder: ''});
    });
    
    document.addEventListener('turbo:render', function() {
      initSearchableSelects($('.searchable-select-input'), {placeholder: ''});
    });
    
    // Turbolinks support (Rails 5-6)
    document.addEventListener('turbolinks:load', function() {
      initSearchableSelects($('.searchable-select-input'), {placeholder: ''});
    });
    
    // Legacy support
    document.addEventListener('page:load', function() {
      initSearchableSelects($('.searchable-select-input'), {placeholder: ''});
    });
    
    // ActiveAdmin has_many support
    $(document).on('has_many_add:after', '.has_many_container', function(e, fieldset) {
      initSearchableSelects(fieldset.find('.searchable-select-input'));
    });
  });
})();