require 'test_helper'

class PublicControllerTest < ActionController::TestCase
  
  include ApplicationHelper
  
  def setup
    @petko = User.find_by_username("petko")
  end
  
  def test_successfull_login
    post :login, { :user => { :username => @petko.username, :password => "1234" } }
    assert user_logged?
    assert_equal @petko.id, session[:user_id]
  end
  
  def test_wrong_login
    post :login, { :user => { :username => @petko.username, :password => "everything but petko's" } }
    assert !user_logged?
  end
  
end
