class RegistrationController < ApplicationController
    skip_before_action :check_token_authorization, :check_email_confirmed, only: [:create, :confirm_email]
    rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record

    def create
        if !registration_params[:password]
            render json: {
                error: "Password is required"
            }, status: :unprocessable_entity  # 422
            return
        end

        # assert that both email and username are given
        if !registration_params[:email] || !registration_params[:username]
            render json: {
                error: "Email and username are required"
            }, status: :unprocessable_entity  # 422
            return
        end

        user = User.create!(registration_params)
        
        render json: { 
            message: "User created successfully. Please confirm your email."
        }, status: :created

        UserMailer.confirmation_email(user).deliver_now!
    end

    def confirm_email
        confirmation_token = email_confirmation_params[:confirmation_token]
        user = User.find_by(confirmation_token: confirmation_token)
        if user.present?
            user.confirm!
            render json: {
                message: "Email confirmed successfully"
            }, status: :ok
        else
            render json: {
                error: "Invalid confirmation token"
            }, status: :unprocessable_entity
        end
    end

    # TODO: Fix -- destroy creates infinte loop
    def delete_account
        current_user.destroy!
        render json: {
            message: "Account deleted successfully"
        }, status: :ok
    end

    private

    def registration_params
        # To force some parameters to be present, we can use the require method
        params.permit(:username, :email, :password, :bio)
    end

    def email_confirmation_params
        params.permit(:confirmation_token)
    end

    def handle_invalid_record(e)
        render json: {
            errors: e.record.errors.full_messages 
        }, status: :unprocessable_entity
    end
end
