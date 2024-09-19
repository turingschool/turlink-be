class Api::V1::SummariesController < ApplicationController

  rescue_from NoMethodError, with: :not_found_error

  def show
    link = Link.find_by(short: params[:link])
    if link.summary == nil || link.summary_timestamp < (Time.current - 259200) #3 days in seconds
      new_summary = SummaryService.new.summarize(link.original)
      link.update(summary: new_summary)
      link.update(summary_timestamp: Time.current)
      render json: LinkSerializer.new(link)
    else
      render json: LinkSerializer.new(link)
    end
  end

  private

  def not_found_error
    render json: { errors: [{ message: 'Link not found in database' }] }, status: :not_found
  end
end
