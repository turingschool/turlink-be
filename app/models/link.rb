require 'securerandom'

class Link < ApplicationRecord
  default_scope { where(disabled: false) }
  
  validates_presence_of :user_id
  validates_presence_of :original
  validates :short, uniqueness: true, presence: true

  belongs_to :user
  has_many :link_tags
  has_many :tags, through: :link_tags

  def self.create_new(user_id, original)
    short = Link.create_short_link
    Link.new(user_id: user_id, original: original, short: short)
  end

  def self.create_short_link
    "tur.link/#{SecureRandom.hex(4)}"
  end
end
