require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:user1)
  end

  test 'login with remembering on' do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test 'login without remembering on' do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end

  test 'login with valid information' do
    get login_path
    post login_path, session: {email: @user.email, password: '123456'}
    assert_redirected_to @user #Check the right redirect page
    follow_redirect! #Actually visits the target page
    assert_template 'users/show' # Asserts that the request was rendered with the appropriate template file.
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
  end

  test 'login with valid information followed by logout' do
    get login_path
    post login_path, session: {email: @user.email, password: '123456'}
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url

    # Simulate a user clicking logout in a second window
    delete logout_path
    follow_redirect!
    assert_select 'a[href=?]', login_path, count: 1
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end

  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: {email: '', password: ''}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end
