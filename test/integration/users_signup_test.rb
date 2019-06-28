require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid user signup information' do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post signup_path, params: { user: {name: '', 
                                        email: 'invalid@user.com',
                                        password: 'foo',
                                        password_confirmation: 'bar' } }
    end
    assert_template 'users/new'
    assert_select '#error_explanation'
    assert_select '.field_with_errors', 6
  end

  test 'valid signup with account activation' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: {name: 'Sample User', 
                                        email: 'invalid@user.com',
                                        password: 'foobarrr',
                                        password_confirmation: 'foobarrr' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?

    # try to login prior to activation
    log_in_as(user)
    assert_not is_logged_in?

    # try to activate with invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?

    # valid token, wrong email
    get edit_account_activation_path(user.activation_token,
                                    email: "wrong@url.com")
    assert_not is_logged_in?

    # valid token & email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end
