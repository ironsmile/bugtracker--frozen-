// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//
//  This object controls the loading message at the top-right (currently) corner
//
LoadingMessage = {
  messages : 0,
  inited : false,
  id : 'loading_message',
  
  init : function(){
    LoadingMessage.inited = true;
    var lmt = new Element("p").update("Loading...");
    var lmimg = new Image()
    lmimg.src = SITE_ROOT+"images/progress_active.gif"
    var lmp = new Element("p").appendChild( lmimg );
    var lmd = new Element("div", { id : LoadingMessage.id, style : 'display:none' }).update( lmt ).insert( lmp )
    $(document.body).appendChild(lmd)
  },
  
  show : function(){
    if( !LoadingMessage.inited ){
      LoadingMessage.init()
    }
    if ( LoadingMessage.messages < 1 ){
      $(LoadingMessage.id).show();
    }
    LoadingMessage.messages += 1;
  },
  
  hide : function(){
    LoadingMessage.messages -= 1;
    if( LoadingMessage.messages < 1 ){
      $(LoadingMessage.id).hide();
      LoadingMessage.messages = 0;
    }
  }
}

// for the registration forms
function put_ajax_loading_img(el_id,image_path){
  var e = $(el_id);
  e.absolutize();
  e.update("<img src='"+image_path+"' alt='loading...' title='loading...' />")
}

function put_loading_message(){ // kept for backward compability
  LoadingMessage.show();
}

function hide_loading_message(){ // kept for backward compability
  LoadingMessage.hide();
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