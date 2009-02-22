require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  include ApplicationHelper
  
  def setup
    @user = { :username => "gosheto", :password => "secret", :email => "gosheto@somewhere.here" }
    @others = { :pass_confirm => "secret" }
    @petko = User.find_by_username("petko")
  end
  
  def test_create_action_successfull
    post :create, { :user => @user, :others => @others }
    
    saved_user = User.find_by_username_and_password( @user[:username], hash_string(@user[:password]) )
    
    instance_user = assigns(:user)
    
    assert_equal instance_user, saved_user
    assert_not_nil saved_user

    assert_equal @user[:email], saved_user.email
    assert_equal @user[:username], saved_user.username
    assert_equal hash_string(@user[:password]), saved_user.password
    assert saved_user.full_name.nil?
    assert_equal 0, saved_user.user_type_id
    assert saved_user.persistent_login.nil?
    assert user_logged?
    assert_equal saved_user.id, session[:user_id]
  end
  
  def test_create_with_blank_or_wrong_password
    @user[:password] = ""
    post :create, { :user => @user, :others => @others }
    assert_response :success
    
    user = User.find_by_username(@user[:username])
    assert user.nil?
    
    assert_tag "form", :attributes => { :method => "post", :action => "/users" }
    assert_tag "input", :attributes => { :type => "text", :name => "user[username]", :value => @user[:username] }
    
    @user[:password] = "not a secret"
    post :create, { :user => @user, :others => @others }
    assert_response :success
    user = User.find_by_username(@user[:username])
    assert user.nil?
  end
  
  def test_no_access_to_our_guts_when_not_authenticated
    get :edit, { :id => @petko.username }
    assert_response :redirect
    assert_redirected_to :controller => "public", :action => "login"
    log_user_in!
    assert user_logged?
    get :edit
    assert_response :success
  end
  
  private
  
  def log_user_in!
    post :create, { :user => @user, :others => @others }
  end
  
end
