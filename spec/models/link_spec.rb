require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:original) }
    it { should validate_presence_of(:short) }
    it 'should validate presence of user_id' do
      user = User.create(email: 'james@example.com', password: 'james123')
      link = Link.new(original: 'www.example.com', short: 'tur.link/12345678', user_id: user.id)
      expect(link).to be_valid
    end
    it { should validate_presence_of(:user_id) }
  end

  describe 'relationships' do
    it { should belong_to :user }
    it { should have_many :link_tags }
    it { should have_many(:tags).through(:link_tags) }
  end

  describe 'methods' do
    describe 'create_new' do
      it 'can create a new link' do
        user1 = User.create(email: 'user@example.com', password: 'user123')
        link = Link.create_new(user1.id, 'long-link-example.com')

        expect(link).to be_a Link
        expect(link.user_id).to eq(user1.id)
        expect(link.original).to eq('long-link-example.com')
        expect(link.short).to be_a String
      end
    end

    describe '.create_short_link' do
      it 'creates a unique short link' do
        short1 = Link.create_short_link
        short2 = Link.create_short_link
        expect(short1).not_to eq(short2)
      end
    end

    describe '#update_privacy' do
      it 'updates the privacy setting' do
        user = User.create!(email: 'test@example.com', password: 'password')
        link = Link.create!(user:, original: 'https://example.com', short: 'tur.link/abc123', private: false)
        link.update_privacy(true)
        expect(link.reload.private).to be true
      end
    end

    describe 'default scope' do
      it 'excludes disabled links' do
        user = User.create!(email: 'test@example.com', password: 'password')
        Link.create!(user:, original: 'https://example1.com', short: 'tur.link/abc123', disabled: false)
        Link.create!(user:, original: 'https://example2.com', short: 'tur.link/def456', disabled: true)
        expect(Link.count).to eq(1)
      end
    end
  end
end
