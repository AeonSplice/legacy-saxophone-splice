require 'rails_helper'

RSpec.describe User do
  subject { build :user }

  it 'has a valid factory' do
    is_expected.to be_valid
  end

  #############
  ## Queries ##
  #############

  describe '#can_remove_auth?(authentication)' do
    it 'returns false for auth not belonging to user' do
      user = create :user
      auth = build :authentication
      expect(user.can_remove_auth?(auth)).to be_falsey
    end

    it 'returns false if user has one auth and no password' do
      user = create :user, :without_password, :with_one_auth
      auth = user.authentications.first
      expect(user.can_remove_auth?(auth)).to be_falsey
    end

    it 'returns true if user has a password' do
      user = create :user
      auth = build :authentication, user: user
      expect(user.can_remove_auth?(auth)).to be_truthy
    end

    it 'returns true if user has two auths' do
      user = create :user, :without_password, :with_two_auths
      auth = user.authentications.first
      expect(user.can_remove_auth?(auth)).to be_truthy
    end
  end

  describe '#activated?' do
    it 'returns true if user is active' do
      user = build :user, :active
      expect(user.activated?).to be_truthy
    end

    it 'returns false is user is not active' do
      user = build :user, :pending
      expect(user.activated?).to be_falsey
    end
  end

  describe '#meta_present?' do
    it 'returns false if no meta present' do
      user = build :user, locale: 'en', timezone: 'UTC'
      expect(user.meta_present?).to be_falsey
    end

    it 'returns true if user has realname' do
      user = build :user, realname: 'Test User'
      expect(user.meta_present?).to be_truthy
    end

    it 'returns true if user has nickname' do
      user = build :user, nickname: 'Test User'
      expect(user.meta_present?).to be_truthy
    end

    it 'returns true if user has bio' do
      user = build :user, bio: 'I like trains.'
      expect(user.meta_present?).to be_truthy
    end

    it 'returns true if user has location' do
      user = build :user, location: 'The Internet'
      expect(user.meta_present?).to be_truthy
    end

    it 'returns true if user has foreign locale' do
      user = build :user, locale: 'es'
      expect(user.meta_present?).to be_truthy
    end

    it 'returns true if user has non-UTC timezone' do
      user = build :user, timezone: 'PT'
      expect(user.meta_present?).to be_truthy
    end
  end
end
