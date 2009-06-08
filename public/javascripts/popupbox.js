/*
* Doycho 06 June 2009
* popupbox. Inspired and almost copied from Facebox (http://famspam.com/facebox/).
* Only that this is a simplier and needs prototype to work (instead of jQuery)
* 
* ver 0.1
* 
* 
* Usage
* 

  document.observe("dom:loaded", function() {
    $$('a[rel*=popupbox]').each(function(a){
      popupbox.forAnchor(a);
    });
  });
    
*  <a href="#terms" rel="facebox">Terms</a>
*    Loads the #terms div in the box
*
*  <a href="terms.html" rel="facebox">Terms</a>
*    Loads the terms.html page in the box
*
*  <a href="terms.png" rel="facebox">Terms</a>
*    Loads the terms.png image in the box
* 
*/

//  If Ruby's (or whoevers) fade and appear effects are present using them
//  if not - show and hide
if( !Element.fade || !Element.appear ){
  Element.addMethods({
    fade    : function(element){ element.hide() },
    appear  : function(element){ element.show() }
  });
}


popupbox = {

  forAnchor : function(a){
    var oldhref = a.href;
    a.observe('click',function(e){popupbox.fill(oldhref);});
    a.href="javascript:void(0);"
  },

  init : function(){
    if( popupbox.inited ) return true;
    popupbox.inited = true;
    
    $(document.body).insert(popupbox.settings.popupboxHtml);
    $$("#popupbox .close")[0].observe('click', popupbox.close);
    
    // preload our images :)
    var preload = [ new Image(), new Image() ]
    preload[0].src = popupbox.settings.closeImage
    preload[1].src = popupbox.settings.loadingImage
    
    if( Mover && Mover.init ){
      $$("#popupbox ."+popupbox.settings.moveHandlerClass).each(function(item){
        Mover.init(item, 'popupbox');
      });
    }
  },
  
  close : function(){
    $('popupbox').fade();
  },
  
  loading : function(){
    popupbox.init();
    if ($$('#popupbox .loading').length == 1) return true;
    $$("#popupbox .footer")[0].hide();
    $$("#popupbox .content")[0].update('<div class="loading"><img src="'+popupbox.settings.loadingImage+'"/></div>');
    $('popupbox').setStyle({
      top: getPageScroll()[1] + (getPageHeight() / 10) + 'px',
      left: '185.5px'
    }).appear();
//     popupbox.center();
  },
  
  // fills the .content with the stuff :)
  // to be called after loading if done programatically :)
  display : function( stuff ){
    popupbox.loading();
    if( !$('popupbox').visible() ) $('popupbox').appear();
    $$("#popupbox .footer")[0].show();
    $$("#popupbox .close")[0].update('<img src="'+popupbox.settings.closeImage+'" title="close" alt="Close" class="close_image" />');
    $$("#popupbox .content")[0].update(stuff).show();
  },
  
  fillImage : function( src ){
    var img = new Image();
    img.onload = function(){
      popupbox.display("<img src='"+src+"' alt='' onclick='popupbox.close()' />");
    }
    img.src = src
  },
  
  fillFromAjax : function( href ){
    new Ajax.Request(href, {
      method: 'get',
      onSuccess: function(transport) {
        popupbox.display(transport.responseText);
      },
      onFailure : function(transport){
        popupbox.display("Error with your ajax request!");
      }
    });
  },
  
  // determines how to fill the popupbox on the href.
  fill : function( href ){
    popupbox.loading();
    
    if( href.match( /#([\w\d]+)$/ ) ){
      popupbox.display( $(href.split("#")[1]).innerHTML );
    }
    else if ( href.match( /\.(jpe?g|png|gif)$/ ) ){
      popupbox.fillImage(href);
    }
    else {
      popupbox.fillFromAjax(href);
    }
      
  },
  
  center : function(){
//     alert($('popupbox').getWidth());
    $('popupbox').setStyle( { 'left' :  document.viewport.getDimensions().width / 2 - ($('popupbox').getWidth() / 2) } )
  }
  
};

// Customize it as much as you want it!
// the only thing to keep in mind:
// the div#popupbox must stay
// the same goes for #popupbox.content, #popupbox.footer, #popupbox.close

popupbox.settings = {
//       opacity      : 0,
//       overlay      : true,s
      loadingImage : 'images/popupbox/loading.gif',
      closeImage   : 'images/popupbox/closelabel.gif',
      moveHandlerClass: 'b' // elements with this class can be draged to move the whole box around
      //imageTypes   : [ 'png', 'jpg', 'jpeg', 'gif' ],
}

popupbox.settings.popupboxHtml  = '\
    <div id="popupbox" style="display:none;"> \
      <div class="popup"> \
        <table> \
          <tbody> \
            <tr> \
              <td class="tl"/><td class="b"/><td class="tr"/> \
            </tr> \
            <tr> \
              <td class="b"/> \
              <td class="body"> \
                <div class="content"> \
                </div> \
                <div class="footer"> \
                  <a href="javascript:void(0);" class="close"> \
                    <img src="'+popupbox.settings.closeImage+'" title="close" alt="Close" class="close_image" /> \
                  </a> \
                </div> \
              </td> \
              <td class="b"/> \
            </tr> \
            <tr> \
              <td class="bl"/><td class="b"/><td class="br"/> \
            </tr> \
          </tbody> \
        </table> \
      </div> \
    </div>'


// getPageScroll() by quirksmode.com
function getPageScroll() {
  var xScroll, yScroll;
  if (self.pageYOffset) {
    yScroll = self.pageYOffset;
    xScroll = self.pageXOffset;
  } else if (document.documentElement && document.documentElement.scrollTop) {   // Explorer 6 Strict
    yScroll = document.documentElement.scrollTop;
    xScroll = document.documentElement.scrollLeft;
  } else if (document.body) {// all other Explorers
    yScroll = document.body.scrollTop;
    xScroll = document.body.scrollLeft; 
  }
  return new Array(xScroll,yScroll) 
}

// Adapted from getPageSize() by quirksmode.com
function getPageHeight() {
  var windowHeight
  if (self.innerHeight) { // all except Explorer
    windowHeight = self.innerHeight;
  } else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
    windowHeight = document.documentElement.clientHeight;
  } else if (document.body) { // other Explorers
    windowHeight = document.body.clientHeight;
  } 
  return windowHeight
}