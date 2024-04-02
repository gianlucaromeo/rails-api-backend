Rails.application.routes.draw do
  # Application
  get "/refreshToken", to: "application#refresh_token"
  
  # Registration
  post "/register", to: "registration#create"
  get "/confirmEmail", to: "registration#confirm_email"
  delete "/deleteAccount", to: "registration#delete_account"
  
  # Login
  post "/login", to: "login#login"

  # Password
  post "/passwordForgotten", to: "password#password_forgotten"
  post "/resetPassword", to: "password#reset_password"

  # User
  get "/me", to: "users#me"

  # To set a root path
  root to: "application#root"
end
