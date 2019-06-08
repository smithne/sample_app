require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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

  test 'valid signup' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: {name: 'Sample User', 
                                        email: 'invalid@user.com',
                                        password: 'foobarrr',
                                        password_confirmation: 'foobarrr' } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_select '.alert'
    assert_select '.alert-success'
  end

end
