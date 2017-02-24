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

  describe '#language' do
    I18n.available_locales.each do |locale|
      language = I18n.t('language', locale: locale)
      it "returns #{language} for :#{locale.to_s}" do
        user = build :user, locale: locale
        expect(user.language).to eq(language)
      end
    end
  end

  describe '#sanitize_timezone' do
    it 'sets timezone to PT for -8' do
      user = build :user, timezone: '-8'
      user.sanitize_timezone
      expect(user.timezone).to eq('Pacific Time (US & Canada)')
    end

    it 'sets timezone to ET for ET' do
      user = build :user, timezone: 'Eastern Time (US & Canada)'
      user.sanitize_timezone
      expect(user.timezone).to eq('Eastern Time (US & Canada)')
    end

    it 'sets timezone to UTC for invalid timezone' do
      user = build :user, timezone: 'All your base are belong to us.'
      user.sanitize_timezone
      expect(user.timezone).to eq('UTC')
    end

    it 'does nothing when timezone is nil' do
      user = build :user, timezone: nil
      user.sanitize_timezone
      expect(user.timezone).to eq(nil)
    end
  end

  describe '#sanitize_locale' do
    it 'sets locale to ja for ja' do
      user = build :user, locale: 'ja'
      user.sanitize_locale
      expect(user.locale).to eq('ja')
    end

    it 'sets locale to el for :el' do
      user = build :user, locale: :el
      user.sanitize_locale
      expect(user.locale).to eq('el')
    end

    it 'sets locale to el for el_GR' do
      user = build :user, locale: 'el_GR'
      user.sanitize_locale
      expect(user.locale).to eq('el')
    end

    it 'sets locale to ja for ja-JP' do
      user = build :user, locale: 'ja-JP'
      user.sanitize_locale
      expect(user.locale).to eq('ja')
    end

    it 'sets locale to default locale for valid but unavailable locale' do
      user = build :user, locale: 'ru'
      user.sanitize_locale
      expect(user.locale).to eq(I18n.default_locale.to_s)
    end

    it 'sets locale to default locale for invalid locale' do
      user = build :user, locale: 'its_a-trap!'
      user.sanitize_locale
      expect(user.locale).to eq(I18n.default_locale.to_s)
    end

    it 'does nothing when locale is nil' do
      user = build :user, locale: nil
      user.sanitize_locale
      expect(user.locale).to eq(nil)
    end
  end
end
