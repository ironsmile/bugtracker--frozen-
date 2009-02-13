module PublicHelper

  def nav_link( name, opts, cls = 'active' )
    link_to_unless_current( name, opts ){ |n| "<span class='#{cls}'>#{n}</span>" }
  end
  
end
