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
  end
end
