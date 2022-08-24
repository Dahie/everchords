// This is a manifest file that'll be compiled into application.js, which will include all the files
import "@fontsource/fira-code"
import "jquery"
import "fomantic-ui"

$('.notebooks .item').tab();
$('.ui.accordion').accordion({exclusive: false});

$('.ui.modal.addNotebook')
  .modal('attach events', '.ui.button.addNotebook', 'show');
$('.ui.modal.debugInfo')
  .modal('attach events', '.item .openDebugInfo', 'show');

$('.ui.search').search({
  apiSettings: {
    url: '/search/{query}'
  },
  type: 'category',
  minCharacters : 3
});

