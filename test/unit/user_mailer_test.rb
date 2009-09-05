require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  tests UserMailer

  def test_forgotten_pass_mail
    user = users(:petko)
    email = UserMailer.deliver_forgotten_password(user, "alabala")
    assert !ActionMailer::Base.deliveries.empty? 
    assert_equal [user.email], email.to 
  end
  
end
