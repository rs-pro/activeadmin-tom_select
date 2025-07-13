import select2 from 'select2/dist/js/select2'
select2($);

import "flowbite"
import "@activeadmin/activeadmin/dist/active_admin/features/batch_actions"
import "@activeadmin/activeadmin/dist/active_admin/features/dark_mode_toggle"
import "@activeadmin/activeadmin/dist/active_admin/features/has_many"
import "@activeadmin/activeadmin/dist/active_admin/features/filters"
import "@activeadmin/activeadmin/dist/active_admin/features/main_menu"
import "@activeadmin/activeadmin/dist/active_admin/features/per_page"

// Rails UJS is already started by ActiveAdmin
// import Rails from "@rails/ujs"
// Rails.start();

// Searchable Select functionality
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

$(document).on('has_many_add:after', '.has_many_container', function(e, fieldset) {
  initSearchableSelects(fieldset.find('.searchable-select-input'));
});

$(document).on('page:load turbo:load turbolinks:load', function() {
  initSearchableSelects($(".searchable-select-input"), {placeholder: ""});
});

$(function() {
  console.log('Searchable select initializing...');
  var inputs = $(".searchable-select-input");
  console.log('Found inputs:', inputs.length);
  initSearchableSelects(inputs);
});