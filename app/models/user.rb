class User < ActiveRecord::Base
  validates_format_of :email, 
                      :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  validates_format_of :username, 
                      :with => /[a-zA-Z\d_ ]{5,}/i,
                      :message => "must contains letters, digits, spaces or underscores! Minimum length - 5 characters."
  
  validates_uniqueness_of :email, :message => "User with that email already exists!"
  validates_uniqueness_of :username, :message => "User with that username already exists!"
  validates_presence_of :password
  
  def login!(session)
    session[:user_id] = self.id
  end
  
  def self.log_out!(session)
    session[:user_id] = nil
  end
  
  def clear_password!
    self.password = nil
  end
end
