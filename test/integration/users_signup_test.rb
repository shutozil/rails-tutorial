require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid signup information" do
    get signup_path
    
    # フォーム送信をテスト
    # assert_no_differenceのブロックを実行する前後で引数の値 (User.count) 
    ## また、上のコードではgetメソッドを使っていないことにも注目してください。
    ## これは各メソッドに技術的な関連性がなく、ユーザー登録ページにアクセスしなくても、
    ## 直接postメソッドを呼び出してユーザー登録ができることを意味しています。
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    
    assert_template 'users/new'
    assert_select 'div#error_explanation', 1
    assert_select 'div.field_with_errors', 8

  end
  
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    # 筆者の場合、flashが空でないかをテストするだけの場合が多いです。
    assert_not flash.blank?
  end
  
end
