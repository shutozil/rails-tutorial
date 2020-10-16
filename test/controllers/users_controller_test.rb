require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:michael)
    @other_user = users(:archer)
  end

  # test "should get index" do
  #   get users_url
  #   assert_response :success
  # end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  # test "should create user" do
  #   assert_difference('User.count') do
  #     post users_url, params: { user: { email: @user.email, name: @user.name } }
  #   end

  #   assert_redirected_to user_url(User.last)
  # end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  # test "should get edit" do
  #   get edit_user_url(@user)
  #   assert_response :success
  # end

  # test "should update user" do
  #   patch user_url(@user), params: { user: { email: @user.email, name: @user.name } }
  #   assert_redirected_to user_url(@user)
  # end

  # test "should destroy user" do
  #   assert_difference('User.count', -1) do
  #     delete user_url(@user)
  #   end

  #   assert_redirected_to users_url
  # end
  
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user) # アーチャーでログイン
    get edit_user_path(@user) # マイケルのeditページにアクセス
    assert flash.empty? # flashがないことを期待
    assert_redirected_to root_url # リダイレクト先はルートであることを期待
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin? # falseが返ることを期待
    patch user_path(@other_user), params: {
                                    user: { password:              "password",
                                            password_confirmation: "password",
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end
  
  # ログインしていないユーザはユーザの削除ができない
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end
  
  # ログインしていてもadminがtrueじゃないとユーザの削除ができない
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
  
end
