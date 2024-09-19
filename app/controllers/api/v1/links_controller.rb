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
    if link && (!link.private? || (current_user && link.user_id == current_user.id))
      link.increment!(:click_count)
      link.update(last_click: Time.current)
      render json: LinkSerializer.new(link)
    else
      not_found_error
    end
  end

  def top_links
    query = Link.where(private: false).order(click_count: :desc).limit(5)

    if params[:tag].present?
      tags = params[:tag].split(',').map(&:strip)
      query = query.joins(:tags).where(tags: { name: tags })
      query = query.group('links.id').having('COUNT(DISTINCT tags.id) = ?', tags.size)
    end
    
    links = query.distinct

    links.each do |link|
      begin
        if link.summary == nil || link.summary_timestamp < (Time.current - 259200) #3 days in seconds
          new_summary = SummaryService.new.summarize(link.original)
          link.update(summary: new_summary)
          link.update(summary_timestamp: Time.current)
        end
      rescue Faraday::ConnectionFailed => e
          link.update(summary: "Summary not available")
          link.update(summary_timestamp: Time.current)
      end
    end

    render json: LinkSerializer.new(links)
  end

  def update_privacy
    user = User.find(params[:user_id])
    link = Link.find(params[:id])
    is_private = params[:private] == 'true'

    if link.user_id == user.id
      if link.update(private: is_private)
        render json: { message: 'Privacy setting updated successfully' }, status: :ok
      else
        render json: { error: 'Failed to update privacy setting' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized to update this link' }, status: :forbidden
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User or Link not found' }, status: :not_found
  end

  private

  def not_found_error
    render json: { errors: [{ message: 'Record not found' }] }, status: :not_found
  end
end
