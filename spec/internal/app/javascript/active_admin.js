// Import ActiveAdmin - this already includes all features and Rails UJS
// DO NOT import Rails separately as it's already included and started in ActiveAdmin
import '@activeadmin/activeadmin';

// Import Tom Select
import TomSelect from 'tom-select';
// Make it globally available for the searchable select init
window.TomSelect = TomSelect;

// Import and setup ActiveAdmin Searchable Select  
import { setupAutoInit, initSearchableSelects } from '@rocket-sensei/activeadmin-searchable_select';

// Make the init function globally available for tests
window.initSearchableSelects = initSearchableSelects;

// Initialize the module after everything is loaded
setupAutoInit();

console.log('ActiveAdmin JS loaded with Tom Select and Searchable Select');