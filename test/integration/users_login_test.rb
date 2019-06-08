require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test 'login fails with invalid credentials' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {email: 'bademail@baddomain.gov',
                              password: 'failedpassword' }}
    assert_template 'sessions/new'
    assert_select '.alert-danger'
    get root_path
    assert_select '.alert-danger', 0
  end


  test 'login succeeds with valid credentials' do

  end
end
