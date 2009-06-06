/*
* Doycho 06 June 2009
* simple mechanism for making movable HTML elements
* ver 0.1
* 
* Requires prototype >= 1.6
* 
* usage:
* Mover.init( 'holder', 'target' );
* 
* the 'holder' element is the one on you should click to start moving the 'target' element
*/

Mover = {
  init : function( holder, target ){
    holder = $(holder);
    holder._target = $(target);
    
    holder.observe("mousedown", function(e){
      var mobj = document._moving = $(holder._target);
      document._moving._click_coords = {  x: e.pointerX()-parseInt(mobj.getStyle('left')) , 
                                          y: e.pointerY()-parseInt(mobj.getStyle('top')) };
                                          
      $(document).observe("mousemove", Mover.document_mousemove );
      $(document).observe("mouseup", Mover.document_mouseup );
    });
  },
  
  document_mousemove : function(e){
    var mobj = document._moving;
    mobj.setStyle({ 'top': (e.pointerY() - mobj._click_coords.y) + 'px' , 
                    'left': (e.pointerX() - mobj._click_coords.x) + 'px' });
  },
  
  document_mouseup : function(e){
    Event.stopObserving($(document), 'mousemove', Mover.document_mousemove );
    Event.stopObserving($(document), 'mouseup', Mover.document_mouseup );
  }
};