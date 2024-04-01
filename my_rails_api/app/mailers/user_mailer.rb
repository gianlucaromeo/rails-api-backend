class UserMailer < ApplicationMailer
    def confirmation_email(user)
        confirmation_link = url_for(
            controller: 'registration',
            action: 'confirm_email', 
            confirmation_token: user.confirmation_token,
            only_path: false,
        ) 
        
        mail(
            from: ENV["GMAIL_USERNAME"],
            to: user.email,
            subject: 'Email Confirmation') do |format|
                format.text { 
                    render plain: "Welcome, #{user.username}!\nClick the link below to confirm your email:\n#{confirmation_link}"
                }
            end
        
        puts "Confirmation link: #{confirmation_link}"
    end

    def password_reset_email(user)
        password_reset_link = url_for(
            controller: 'password',
            action: 'reset_password', 
            password_reset_token: user.password_reset_token,
            only_path: false,
        )

        mail(
            from: ENV["GMAIL_USERNAME"],
            to: user.email,
            subject: 'Password Reset') do |format|
                format.text { 
                    render plain: "Hello, #{user.username}!\nClick the link below to reset your password:\n#{password_reset_link}"
                }
            end
        
        puts "Password reset link: #{password_reset_link}"
    end
end
