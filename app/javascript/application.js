// This is a manifest file that'll be compiled into application.js, which will include all the files
import "jquery";
import "fomantic-ui"
import "controllers"
import {Turbo} from "@hotwired/turbo-rails"



const initFomantic = function() {
  if($('.notebooks .notebook.item').length > 0) {
    $('.notebooks .notebook.item').tab();
  }
  
  if($('.ui.accordion').length > 0) {
    $('.ui.accordion').accordion({exclusive: false});
  }

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
}

document.addEventListener("turbo:load", initFomantic);
document.addEventListener("turbo:frame-load", initFomantic);
