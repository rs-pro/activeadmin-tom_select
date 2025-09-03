// Import ActiveAdmin - this already includes all features and Rails UJS
// DO NOT import Rails separately as it's already included and started in ActiveAdmin
import '@activeadmin/activeadmin';

// Import jQuery and make it globally available BEFORE loading Select2
import $ from 'jquery';
window.$ = window.jQuery = $;

// Import Select2 and explicitly attach it to jQuery
import select2 from 'select2';
select2($); // Critical: Initialize Select2 on jQuery

// Import and setup ActiveAdmin Searchable Select  
import { setupAutoInit } from '@rocket-sensei/activeadmin-searchable_select';

// Initialize the module after everything is loaded
setupAutoInit();