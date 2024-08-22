class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      render json: UserSerializer.new(user), status: :created
    else
      render json: ErrorSerializer.new(user, :unprocessable_entity).serialize, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
