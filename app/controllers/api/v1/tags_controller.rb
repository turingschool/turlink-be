class Api::V1::TagsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    if params[:link].present?
      link = Link.find(params[:link])
      render json: LinkSerializer.new(link)
    else
      tags = Tag.all
      render json: TagSerializer.new(tags)
    end
  end

  def create
    link = Link.find(params[:link])
    if params[:tag].present?
      tag = Tag.find(params[:tag])
      create_link_tag(link, tag)
    elsif params[:newTag].present?
      tag = Tag.create_new(params[:newTag])
      create_link_tag(link, tag)
    else
      not_found_error
    end
  end

  def destroy
    link = Link.find(params[:link])
    tag = Tag.find(params[:id])
    link_tag = LinkTag.find_by(link_id: link.id, tag_id: tag.id)
    link_tag.destroy
    render json: LinkSerializer.new(link)
  end

  private

  def not_found_error
    render json: { errors: [{ message: 'Link or Tag not found' }] }, status: :not_found
  end

  def create_link_tag(link, tag)
    link_tag = LinkTag.new(link_id: link.id, tag_id: tag.id)
    if link_tag.save
      render json: LinkSerializer.new(link)
    end
  end
end