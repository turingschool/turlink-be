class Link < ApplicationRecord
  validates_presence_of :user_id
  validates_presence_of :original
  validates :short, uniqueness: true, presence: true

  belongs_to :user
end
