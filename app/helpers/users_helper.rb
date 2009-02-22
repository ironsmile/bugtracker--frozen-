module UsersHelper

  include Avatar::View::ActionViewSupport
  
  USERS_DEFAULT_AVATAR = "#{ApplicationHelper::SITE_URL}images/no-avatar.gif"
  
  
  def avatar_for(user)
    avatar_tag(user, {:size => 100, :gravatar_default_url => USERS_DEFAULT_AVATAR})
  end
  
end
