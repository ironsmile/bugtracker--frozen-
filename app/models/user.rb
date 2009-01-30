class User < ActiveRecord::Base
  validates_format_of :email, 
                      :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  validates_format_of :username, 
                      :with => /\w[\w\d_]{4,}/i,
                      :message => "must contains letters, digits or dashes! Minimum length - 5 characters."
  
  validates_uniqueness_of :email, :message => "User with that email already exists!"
  validates_uniqueness_of :username, :message => "User with that username already exists!"
  validates_presence_of :password
  
  def set_password(val)
    require 'digest/md5'
    option = Configuration.find_by_name "db_salt"
    if option.nil?
      self.errors[:password_hashing] = "No database salt found!"
      return
    end
    self.password = Digest::MD5.hexdigest( "#{option.value}#{val}42" )
  end
end
