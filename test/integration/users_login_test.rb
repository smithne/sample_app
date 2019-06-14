require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'login fails with invalid credentials' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: 'bademail@baddomain.gov',
                              password: 'failedpassword' } }
    assert_template 'sessions/new'
    assert_select '.alert-danger'
    get root_path
    assert_select '.alert-danger', 0
  end


  test 'login succeeds with valid credentials then logs out' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email, 
                                          password: 'password' } }
                                          assert_redirected_to @user
    assert is_logged_in?
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test 'creates cookies when remember me is checked upon login' do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end

  test "login without remembering" do
    # Log in to set the cookie.
    log_in_as(@user, remember_me: '1')
    # Log in again and verify that the cookie is deleted.
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end



end
