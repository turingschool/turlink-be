class Tag < ApplicationRecord
  validates_presence_of :name

  has_many :link_tags
  has_many :links, through: :link_tags

  def self.create_new(new_tag)
    tag = where("name ILIKE ?", new_tag.strip)
    if tag != []
      return tag[0]
    else
      return Tag.create(name: new_tag.strip)
    end
  end
end
