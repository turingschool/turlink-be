class UserSerializer
  include JSONAPI::Serializer
  attributes :email, :links
end
