// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// for the forms
function put_ajax_loading_img(el_id,image_path){
  var e = $(el_id);
  e.absolutize();
  e.update("<img src='"+image_path+"' alt='loading...' title='loading...' />")
}

function put_loading_message(){
  var e = null;
  if( e = $("loading_message") )
    e.update("Loading...").show();
}

Element.addMethods({

  animatedToggle : function(element){
    element.visible() ? element.fade() : element.appear();
  }
  
});