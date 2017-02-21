require 'rails_helper'

RSpec.describe Article do
  subject { build :article }

  it 'has a valid factory' do
    is_expected.to be_valid
  end
end
