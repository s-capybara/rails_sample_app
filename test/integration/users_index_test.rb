require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @non_admin = users(:archer)
    @unactivated = users(:unactivated)
  end

  test 'index as admin including pagination and delete links' do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      if user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test 'index as non-admin' do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test 'index has only activated users' do
    log_in_as(@user)
    get users_path
    users = assigns(:users)
    assert_not users.include?(@unactivated)
    assert_equal User.count - 1, users.count
  end
end
