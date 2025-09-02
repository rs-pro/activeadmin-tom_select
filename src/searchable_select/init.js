(function() {
  // Wait for jQuery to be available
  if (typeof $ === 'undefined' && typeof jQuery !== 'undefined') {
    window.$ = jQuery;
  }
  
  function initSearchableSelects(inputs, extra) {
    // Ensure select2 is available
    if (!$.fn.select2) {
      console.error('Select2 is not loaded. Please ensure select2 is properly imported.');
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

  $(document).on('has_many_add:after', '.has_many_container', function(e, fieldset) {
    initSearchableSelects(fieldset.find('.searchable-select-input'));
  });

  // Support both Turbolinks and Turbo
  $(document).on('page:load turbolinks:load turbo:load', function() {
    initSearchableSelects($(".searchable-select-input"), {placeholder: ""});
  });

  $(function() {
    initSearchableSelects($(".searchable-select-input"));
  });
}());