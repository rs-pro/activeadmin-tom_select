// jQuery and Select2 are expected to be loaded by the host application
const $ = window.jQuery || window.$;

function initSearchableSelects(inputs, extra) {
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

// Initialize on has_many_add event
$(document).on('has_many_add:after', '.has_many_container', function(e, fieldset) {
  initSearchableSelects(fieldset.find('.searchable-select-input'));
});

// Initialize on page load and turbo events
$(document).on('page:load turbo:load turbolinks:load', function() {
  initSearchableSelects($(".searchable-select-input"), {placeholder: ""});
});

// Initialize on document ready
$(function() {
  console.log('Searchable select initializing...');
  var inputs = $(".searchable-select-input");
  console.log('Found inputs:', inputs.length);
  initSearchableSelects(inputs);
});

export { initSearchableSelects };