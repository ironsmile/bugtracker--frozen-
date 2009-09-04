# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  require 'digest/md5'

  def debug_info_links
    ["params","session","env","request"].map do |v|
      link_to(v,{},{:href=>"##{v}_debug_info", :rel=> "popupbox"})
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
  
  def nav_link( name, opts, htmls = {} )
    htmls = {:tag => 'span', :class => 'active'}.update(htmls)
    link_to_unless_current( name, opts ){ |n| "<#{htmls[:tag]} class='#{htmls[:class]}'>#{n}</#{htmls[:tag]}>" }
  end
  
  def link_to_static(file)
    "#{request.relative_url_root}/#{file}"
  end
  
  def image_href(fname) # image_tag ! n00b!
    link_to_static("images/#{fname}")
  end
  
  def textile_this(string)
    string.gsub! /(\{\{\{\n((.|\n)+?)\}\}\})/ do |match|
      "\n\n<object><pre class='code'><code>#{$2.gsub!(/\n+/, "\n")}</code></pre></object>\n"
    end
    RedCloth.new(string).to_html
  end
  
  def full_url(relative_url)
    SITE_HOST + relative_url
  end
  
  def render_time(t)
    link_to time_ago_in_words(t), "javascript:void(0)", {:title => "#{t}", :class=>"time_in_words"}
  end
  
end
