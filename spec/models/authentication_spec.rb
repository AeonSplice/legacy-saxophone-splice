require 'rails_helper'

RSpec.describe Authentication do
  subject { build :authentication }

  it 'has a valid factory' do
    is_expected.to be_valid
  end

  it 'is invalid without provider' do
    auth = build :authentication, provider: nil
    expect(auth).to be_invalid
  end

  it 'is invalid without uid' do
    auth = build :authentication, uid: nil
    expect(auth).to be_invalid
  end

  it 'is invalid without user' do
    auth = build :authentication, user: nil
    expect(auth).to be_invalid
  end

  it 'is invalid with bad provider' do
    pending 'Need config option to specify available providers'
    auth = build :authentication, provider: 'linkedin'
    expect(auth).to be_invalid
  end

  it 'is invalid when uid duplicated for same provider' do
    create :authentication, provider: 'twitter', uid: '1234'
    auth = build :authentication, provider: 'twitter', uid: '1234'
    expect(auth).to be_invalid
  end

  it 'is valid when uid duplicated for different providers' do
    create :authentication, provider: 'twitter', uid: '1234'
    auth = build :authentication, provider: 'google', uid: '1234'
    expect(auth).to be_valid
  end
end
