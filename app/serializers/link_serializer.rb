class LinkSerializer
  include JSONAPI::Serializer
  attributes :original, :short, :user_id, :tags, :click_count, :last_click, :private, :summary
end
