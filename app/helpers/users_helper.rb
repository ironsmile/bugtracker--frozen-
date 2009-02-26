module UsersHelper

  include Avatar::View::ActionViewSupport
  
  USERS_DEFAULT_AVATAR = "#{ApplicationHelper::SITE_URL}images/no-avatar.gif"
  
  
  def avatar_for(user, size = 100)
    avatar_tag(user, {:size => size, :gravatar_default_url => USERS_DEFAULT_AVATAR})
  end
  
end
