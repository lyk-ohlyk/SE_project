require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: 'lily',
                     email: 'gsgfdsgfg@gmail.com',
                     password: 'foobar',
                     password_confirmation: 'foobar',
                     student_id: '201728001007002')
  end

  subject { @user }
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:student_id)}
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token)}

  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }

  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }

  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:followers) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    it { should be_admin }
  end


  describe 'when email is already taken' do
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

  describe 'when student ID is too short' do
    before { @user.student_id = '01234012340123'}
    it {should_not be_valid}
  end
  describe 'when student ID is too long' do
    before { @user.student_id = '0123401234012340'}
    it {should_not be_valid}
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = 'mismatch' }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = 'a' * 5 }
    it { should_not be_valid }
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

  describe "remember token" do
    before { @user.save }
    it{expect(@user.remember_token).not_to be_nil}
  end

  describe "micropost associations" do
    before { @user.save }
    let!(:older_micropost) do
      FactoryBot.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryBot.create(:micropost, user: @user, created_at: 1.hour.ago)
    end
    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryBot.create(:micropost, user: FactoryBot.create(:user))
      end
      let(:followed_user) { FactoryBot.create(:user) }
      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end
      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end # "status"
  end

  describe "following" do
    let(:other_user) { FactoryBot.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end
    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject{ other_user }
      its(:followers) { should include(@user)}
    end

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }
      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end

end
