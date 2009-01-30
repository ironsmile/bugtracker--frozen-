module PublicHelper
  def nav_link( name, opts, cls = 'active' )
    link_to_unless_current( name, opts ){ |n| "<span class='#{cls}'>#{n}</span>" }
  end
  
  def render_navs
    {
      "Home" => { :controller => "public", :action => "home" },
      "Log in" => { :controller => "public", :action => "login" },
      "Register" => { :controller => "users", :action => "new" },
    }.map{ |name,opts| nav_link name, opts }.join
  end
end
