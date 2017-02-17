require 'rails_helper'

RSpec.describe Authentication do
  subject { build :authentication }

  it 'has a valid factory' do
    is_expected.to be_valid
  end
end
