require 'test_helper'

# Tests for UsersController
class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'should get new' do
    get signup_path
    assert_response :success
  end

  test 'should redirect edit when not loggegd in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user),
          params: {
            user: {
              name: @user.name,
              email: @user.email
            }
          }
    assert_not flash.empty?
    assert_redirected_to login_path
  end
end
