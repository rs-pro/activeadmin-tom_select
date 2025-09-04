// ES Module version for ActiveAdmin 4+ with esbuild/webpack
// The consuming app must import jQuery and Select2 BEFORE importing this module

const MODULE_NAME = 'ActiveAdmin Searchable Select';
const SELECTOR = '.searchable-select-input';
const SELECT2_HIDDEN_CLASS = '.select2-hidden-accessible';

// Helper to get jQuery reference
function getJQuery() {
  return window.jQuery || window.$;
}

// Core initialization function
export function initSearchableSelects(inputs, extra) {
  const $ = getJQuery();
  
  if (!$?.fn) {
    console.error(`${MODULE_NAME}: jQuery not found`);
    return;
  }
  
  // Ensure select2 is available
  if (!$.fn.select2) {
    console.error(`${MODULE_NAME}: Select2 is not loaded. Please ensure select2 is properly imported.`);
    return;
  }
  
  inputs.each(function() {
    const item = $(this);

    // reading from data allows <input data-searchable_select='{"tags": ['some']}'>
    // to be passed to select2
    const options = $.extend(extra || {}, item.data('searchableSelect'));
    const url = item.data('ajaxUrl');

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
  const $ = getJQuery();
  if (!$) {
    console.error(`${MODULE_NAME}: jQuery not found for auto-init`);
    return;
  }

  // Initialize on DOM ready
  $(function() {
    initSearchableSelects($(SELECTOR));
  });

  // Support Turbo (Rails 7+)
  document.addEventListener('turbo:load', function() {
    initSearchableSelects($(SELECTOR), {placeholder: ""});
  });

  // ActiveAdmin 4 uses .has-many-add button click for dynamic content
  $(document).on('click', '.has-many-add', function() {
    setTimeout(function() {
      initSearchableSelects($(`${SELECTOR}:not(${SELECT2_HIDDEN_CLASS})`));
    }, 10);
  });

  console.log(`${MODULE_NAME} initialized`);
}