require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def test_name_method
    @petko = User.find_by_username("petko")
    assert_equal "Petko Napetov", @petko.name
    @petko.name = nil
    assert_equal "petko", @petko.name
    @petko.name = ""
    assert_equal "petko", @petko.name
  end
  
end
