require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test 'invalid signup information' do

    get signup_path
    assert_no_difference "User.count" do
      post users_path, user: {
                         name: 'some',
                         email: 'invalid@invalid',
                         password: '123',
                         password_confirmation: '456'
                     }
    end

    # Checking whether failed submission re-renders the new action
    assert_template 'users/new'
  end

  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path user: {
                                       name: 'someone',
                                       email: 'some@some.com',
                                       password: 'somepassword',
                                       password_confirmation: 'somepassword'
                                   }
    end

    assert_template 'users/show'
  end
end
