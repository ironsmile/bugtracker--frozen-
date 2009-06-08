// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// for the forms
function put_ajax_loading_img(el_id,image_path){
  var e = $(el_id);
  e.absolutize();
  e.update("<img src='"+image_path+"' alt='loading...' title='loading...' />")
}

function put_loading_message(){
//   hide_notices(); // not needed anymore with the fixed-position message
  var e = null;
  if( e = $("loading_message") )
    e.show();
}

function hide_loading_message(){
  hide_element("loading_message");
}

function hide_notices(){
  hide_element("error");
  hide_element("notice");
}

function hide_element(eid){
  var e = null;
  if( e = $(eid) )
    e.hide();
}

function init_preview_popup(){
  if( popupbox._preview ){
     popupbox._preview = false;
    popupbox.close();
    return;
  }
  popupbox._preview = true;

  popupbox.display("");
  var clsbtn = $$("#popupbox .close")[0];
  var content = $$("#popupbox .content")[0];
  content.id = "popup_preview";
  content.setStyle({ width : "700px" });
  Event.stopObserving(clsbtn, 'click');
  clsbtn.observe('click', function(e){
    popupbox.inited = false;
    popupbox._preview = false;
    $('popupbox').remove();
  });
}

Element.addMethods({

  animatedToggle : function(element){
    element.visible() ? element.fade() : element.appear();
  }
  
});