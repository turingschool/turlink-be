require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'relationships' do
    it { should have_many :link_tags }
    it { should have_many(:links).through(:link_tags) }
  end

  describe 'class methods' do
    describe '#create_new' do
      it 'can search database for existing tags - case insensitive, and return the tag' do 
        tag = Tag.create(name: "rails")
        new_tag = Tag.create_new("Rails")
        expect(tag).to eq(new_tag)
      end

      it "will create a new tag if tag does not yet exist" do
        new_tag = Tag.create_new("new topic")
        expect(Tag.last).to eq(new_tag)
        expect(new_tag).to be_a Tag
        expect(new_tag.name).to eq("new topic")
      end
    end
  end

end
