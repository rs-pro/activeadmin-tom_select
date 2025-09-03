// ES Module version for ActiveAdmin 4+ with esbuild/webpack
// The consuming app must import jQuery and Select2 BEFORE importing this module

// Core initialization function
export function initSearchableSelects(inputs, extra) {
  const $ = window.jQuery || window.$;
  
  if (!$ || !$.fn) {
    console.error('ActiveAdmin Searchable Select: jQuery not found');
    return;
  }
  
  // Ensure select2 is available
  if (!$.fn.select2) {
    console.error('ActiveAdmin Searchable Select: Select2 is not loaded. Please ensure select2 is properly imported.');
    return;
  }
  
  inputs.each(function() {
    var item = $(this);

    // reading from data allows <input data-searchable_select='{"tags": ['some']}'>
    // to be passed to select2
    var options = $.extend(extra || {}, item.data('searchableSelect'));
    var url = item.data('ajaxUrl');

    if (url) {
      $.extend(options, {
        ajax: {
          url: url,
          dataType: 'json',

          data: function (params) {
            return {
              term: params.term,
              page: pageParamWithBaseZero(params)
            };
          }
        }
      });
    }

    item.select2(options);
  });
}

function pageParamWithBaseZero(params) {
  return params.page ? params.page - 1 : undefined;
}

// Auto-initialize on common events  
export function setupAutoInit() {
  const $ = window.jQuery || window.$;
  if (!$) {
    console.error('ActiveAdmin Searchable Select: jQuery not found for auto-init');
    return;
  }

  // Initialize on DOM ready
  $(function() {
    initSearchableSelects($(".searchable-select-input"));
  });

  // Support Turbo (Rails 7+)
  document.addEventListener('turbo:load', function() {
    initSearchableSelects($(".searchable-select-input"), {placeholder: ""});
  });

  // ActiveAdmin 4 uses .has-many-add button click for dynamic content
  $(document).on('click', '.has-many-add', function() {
    setTimeout(function() {
      initSearchableSelects($(".searchable-select-input:not(.select2-hidden-accessible)"));
    }, 10);
  });

  console.log('ActiveAdmin Searchable Select initialized');
}