class LinkSerializer
  include JSONAPI::Serializer
  attributes :original, :short, :user_id
end
