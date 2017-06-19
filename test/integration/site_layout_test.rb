require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:simple)
  end

  test 'layout link without logging in' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path, count: 1
    assert_select 'a[href=?]', about_path, count: 1
    assert_select 'a[href=?]', contact_path, count: 1
    get contact_path
    assert_select 'title', full_title('Contact')
    get signup_path
    assert_select 'title', full_title('Sign up')
    get login_path
    assert_select 'title', full_title('Log in')
  end

  test 'layout link with logging in' do
    log_in_as @user
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path, count: 1
    assert_select 'a[href=?]', about_path, count: 1
    assert_select 'a[href=?]', contact_path, count: 1
    assert_select 'a[href=?]', users_path, count: 1
    assert_select 'a[href=?]', user_path(@user), count: 3
    assert_select 'a[href=?]', edit_user_path(@user), count: 1
    assert_select 'a[href=?]', logout_path, count: 1
    get contact_path
    assert_select 'title', full_title('Contact')
    get users_path
    assert_select 'title', full_title('All users')
    get user_path(@user)
    assert_select 'title', full_title('Firstname Familyname')
    get edit_user_path(@user)
    assert_select 'title', full_title('Edit user')
    delete logout_path
    assert_not logged_in?
  end
end
