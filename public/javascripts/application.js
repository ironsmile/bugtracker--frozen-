// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function put_ajax_loading_img(el_id,image_path){
  var e = $(el_id);
  e.absolutize();
  e.update("<img src='"+image_path+"' alt='loading...' title='loading...' />")
}

Element.addMethods({

  animatedToggle : function(element){
    element.visible() ? element.fade() : element.appear();
  }
  
});