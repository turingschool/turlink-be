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
    if link
      link.increment!(:click_count)
      link.update(last_click: Time.current)
      render json: LinkSerializer.new(link)
    else
      not_found_error
    end
  end

  def top_links
    query = Link.order(click_count: :desc).limit(5)

    query = query.joins(:tags).where(tags: { name: params[:tag] }) if params[:tag].present?

    links = query.distinct

    render json: LinkSerializer.new(links)
  end

  private

  def not_found_error
    render json: { errors: [{ message: 'Record not found' }] }, status: :not_found
  end
end
