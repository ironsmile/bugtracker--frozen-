module UsersHelper

  include Avatar::View::ActionViewSupport
  
  USERS_DEFAULT_AVATAR = "#{SITE_URL}images/no-avatar.gif"
  USERS_DEFAULT_AVATAR_SMALL = "#{SITE_URL}images/no-avatar-small.gif"
  
  
  def avatar_for(user, args = {})
    opts = { :size => 100, :default => USERS_DEFAULT_AVATAR  }.update(args)
    avatar_tag(user, {:size => opts[:size], :gravatar_default_url => opts[:default]})
  end
  
end
