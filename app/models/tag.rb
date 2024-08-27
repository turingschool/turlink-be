class Tag < ApplicationRecord
  validates_presence_of :name

  has_many :link_tags
  has_many :links, through: :link_tags
end
