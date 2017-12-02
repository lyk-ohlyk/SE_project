require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: 'lily', email: 'gsgfdsgfg@gmail.com')
  end

  describe 'when name is already taken' do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end
end
