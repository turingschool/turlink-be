class Api::V1::LinksController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def create
    link = Link.create_new(params[:user_id], params[:link])
    if link.save
      render json: LinkSerializer.new(link)
    else
      render json: ErrorSerializer.new(link, :unprocessable_entity).serialize, status: :unprocessable_entity
    end
  end

  def index
    user = User.find(params[:user_id])
    render json: UserSerializer.new(user)
  end

  def show
    link = Link.find_by(short: params[:short])
    render json: LinkSerializer.new(link)
  end

  private

  def not_found_error
    render json: { errors: [{ message: 'Record not found' }] }, status: :not_found
  end

end