class User < ActiveRecord::Base
  
  USERNAME_MIN_SIZE = 5
  USERNAME_REGEXP = Regexp.new("^[a-z0-9_]{#{USERNAME_MIN_SIZE},}$",true)
  EMAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  validates_format_of :email, 
                      :with => EMAIL_REGEXP
  
  validates_format_of :username, 
                      :with => USERNAME_REGEXP,
                      :message => "must contains letters, digits or underscores only! Minimum length - #{USERNAME_MIN_SIZE} characters."
  
  validates_uniqueness_of :email, :message => "User with that email already exists!"
  validates_uniqueness_of :username, :message => "User with that username already exists!"
  validates_presence_of :password
  
  has_many :comments
  has_many :tickets
  belongs_to :group
  
  before_destroy :destroy_cascade
  
  def login!(session)
    session[:user_id] = self.id
  end
  
  def self.log_out!(session)
    session[:user_id] = nil
  end
  
  def clear_password!
    self.password = nil
  end
  
  def admin?
#     self.user_type_id == ADMIN
      self.group and self.group.name == "Admins"
  end
  
  def name
    (self.full_name.nil? or self.full_name.empty?) ? self.username : self.full_name
#     self.full_name || self.username
  end

  def name=(val)
    self.full_name = val
#     self.full_name = ( val.nil? or val.empty? ) ? nil : val
  end
  
  def to_param
    username
  end
  
private
  
  def destroy_cascade
    fn = lambda { |a| a.user_id = nil; a.save }
    comments.each{ |c| fn.call[c] }
    tickets.each{ |t| fn.call[t] }
  end
  
end
