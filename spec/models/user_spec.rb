require 'rails_helper'

RSpec.describe User do
  subject { build :user }

  it 'has a valid factory' do
    is_expected.to be_valid
  end
end
