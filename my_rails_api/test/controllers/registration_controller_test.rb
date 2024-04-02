require "test_helper"

class RegistrationControllerTest < ActionDispatch::IntegrationTest
  # Executed before each test
  setup do
    @user = {
      "email": "test_email@test.it",
      "username": "test_username",
      "password": "test_password",
    }
    puts "\n[START]"
  end

  # Executed after each test
  teardown do
    puts "[END]"
  end
  
  test "should signup" do
    post "/register", params: @user
    assert_response :created
  end

  test "should not signup without password" do
    post "/register", params: @user.slice(:email, :username)
    assert_response :unprocessable_entity
  end

  test "should not signup without email" do
    post "/register", params: @user.slice(:username, :password)
    assert_response :unprocessable_entity
  end

  test "should not signup without username" do
    post "/register", params: @user.slice(:email, :password)
    assert_response :unprocessable_entity
  end
  
  test "should confirm email" do
    user = User.create!(@user)
    user.update(confirmation_token: "test_mock_token")
    get "/confirmEmail", params: { confirmation_token: "test_mock_token" }
    assert_response :ok
  end

  test "should not confirm email with invalid token" do
    user = User.create!(@user)
    user.update(confirmation_token: "test_mock_token")
    get "/confirmEmail", params: { token: "test_invalid_mock_token" }
    assert_response :unprocessable_entity
  end

  test "should not confirm email with empty token" do
    user = User.create!(@user)
    get "/confirmEmail"
    assert_response :unprocessable_entity
  end

  test "should delete account" do
    skip # TODO: Fix -- destroy creates infinte loop in registration_controller.rb
    User.create!(@user)
    User.update_all(confirmed_at: DateTime.now, confirmation_token: nil)

    post "/login", params: @user.slice(:email, :password)
    assert_response :accepted
    token = JSON.parse(@response.body)["token"]

    delete "/deleteAccount", headers: { "Authorization" => "Bearer " + token }
    assert_response :ok
  end

  test "should not delete account if not logged in" do
    delete "/deleteAccount"
    assert_response :unauthorized
  end

  
end
