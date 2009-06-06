# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  require 'digest/md5'

  HASH_SALT = 42
  SITE_HOST = "http://192.168.1.2"
  SITE_URL = "#{SITE_HOST}/bugtracker/"

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
    s = option.nil? ? "" : option.value
    Digest::MD5.hexdigest( "#{s}#{val}#{HASH_SALT}" )
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
  
  def textile_this(string)
    string.gsub! /(\{{{\n((.|\n)+)}}})/ do |match|
      "\n\n<object><pre><code>#{$2.gsub!(/\n+/, "\n")}</code></pre></object>\n"
    end
    RedCloth.new(string).to_html
  end
  
  def full_url(relative_url)
    SITE_HOST + relative_url
  end
  
  def popupbox_init
    'document.observe("dom:loaded", function() {
      $$("a[rel*=popupbox]").each(function(a){
        popupbox.forAnchor(a);
      });
    });'
  end
  
end
