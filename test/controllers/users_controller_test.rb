require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user       = users(:michael)
    @other_user = users(:archer)
    @third_user = users(:lana)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                        user: { password: 'password',
                                password_confirmation: 'password',
                                admin: true}
    }
    @other_user.reload
    assert_not @other_user.admin?
  end

  test "should not allow non-admins to delete users" do
    log_in_as(@other_user)
    delete user_path(@third_user)
    @third_user.reload
    assert_not @third_user.nil?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test "should allow admin to delete users" do
    log_in_as(@user)
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert_redirected_to users_path
  end

end
