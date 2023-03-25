class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_authorized_response

    def create
        user = User.create(user_params)
        if user.valid?
            session[:user_id] = user.id
            render json: user, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        user = User.find_by!(id: session[:user_id])
        render json: user
        # If the user is authenticated, return the user object in the JSON response.
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation)
    end

    def not_authorized_response
        render json: { error: 'NO!' }, status: :unauthorized
    end
end
