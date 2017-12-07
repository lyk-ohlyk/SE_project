require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: 'lily',
                     email: 'gsgfdsgfg@gmail.com',
                     password: 'foobar',
                     password_confirmation: 'foobar')
  end

  subject { @user }
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should be_valid }

  describe 'when name is already taken' do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe 'when name is too long' do
    before{@user.name = 'a'*31}
    it {should_not be_valid}
  end

  describe 'when emails are with mixed case' do
    let(:mixed_email) {'FooMdaB@ExaMPle.cOM'}
    it 'should be saved under lower-case' do
      @user.email = mixed_email
      @user.save
      expect(@user.reload.email).to eq mixed_email.downcase
    end
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = 'mismatch' }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = 'a' * 5 }
    it { should be_invalid }
  end

  describe 'return value of authenticate method' do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }
    describe 'with valid password' do
      it { should eq found_user.authenticate(@user.password) }
    end
    describe 'with invalid password' do
      let(:user_for_invalid_password) { found_user.authenticate('invalid') }
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be false }
    end
  end

end
