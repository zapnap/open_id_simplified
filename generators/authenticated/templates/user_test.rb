require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  def test_should_create_user
    assert_difference 'User.count' do
      user = User.new
      assert user.save
      assert !user.new_record?
    end
  end

  # add your tests here
end
