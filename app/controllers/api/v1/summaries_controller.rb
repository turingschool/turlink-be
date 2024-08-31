class Api::V1::SummariesController < ApplicationController
  def show
    summary = SummaryService.new.summarize
    summary_json = JSON.parse(summary.body, symbolize_names: true)
    render json: SummarySerializer.new(summary_json).serialize_json
  end
end
