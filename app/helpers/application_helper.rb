# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  require 'digest/md5'

  HASH_SALT = 42
  SITE_URL = "http://192.168.1.2/bugtracker/"

  def debug_info_links
    ["params","session","env","request"].map do |v|
      link_to(v,{},{:href=>'javascript:void(0);', :onclick=>"$('#{v}_debug_info').animatedToggle();return false"})
    end.join " | \n"
  end

  def hash_string(val)
    if val.to_s.empty?
      return ""
    end  
    option = Configuration.find_by_name "db_salt"
    if option.nil?
      raise "No db password salt found!"
    end
    Digest::MD5.hexdigest( "#{option.value}#{val}#{HASH_SALT}" )
  end

  def user_logged?
    !session[:user_id].nil?
  end
  
  def nav_link( name, opts, htmls = {:tag => 'span', :class => 'active'} )
    link_to_unless_current( name, opts ){ |n| "<#{htmls[:tag]} class='#{htmls[:class]}'>#{n}</#{htmls[:tag]}>" }
  end
  
  def link_to_static(file)
    "#{request.relative_url_root}/#{file}"
  end
  
  def image_href(fname)
    link_to_static("images/#{fname}")
  end
  
end
