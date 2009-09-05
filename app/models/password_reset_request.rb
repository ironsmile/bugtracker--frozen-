class PasswordResetRequest < ActiveRecord::Base
  has_one :user
end
