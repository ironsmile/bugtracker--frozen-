# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def debug_info_links
    ["params","session","env","request"].map do |v|
      link_to(v,{},{:href=>'javascript:void(0);', :onclick=>"$('#{v}_debug_info').toggle();return false"})
    end.join " | \n"
  end

  def hash_string(val)
    require 'digest/md5'
    option = Configuration.find_by_name "db_salt"
    if option.nil?
      raise "No db password salt found!"
    end
    Digest::MD5.hexdigest( "#{option.value}#{val}42" )
  end

  def user_logged?
    !session[:user_id].nil?
  end
end
