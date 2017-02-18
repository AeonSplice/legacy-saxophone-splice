require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper do
  describe 'show errors' do
    it 'renders all errors' do
      user = build :user, :without_password
      user.save
      expect(user.errors[:password].count > 0).to be_truthy
      result = helper.show_errors(user, :password)
      user.errors[:password].each do |err|
        expect(result).to include('Password ' + err)
      end
    end
  end

  describe 'provider icon' do
    ['Facebook', 'Google', 'Twitter'].each do |provider|
      it "renders div with #{provider} icon" do
        expect(helper.provider_icon(provider)).to include("fa fa-#{provider.downcase}")
      end
    end

    it 'renders div with microsoft icon' do
      expect(helper.provider_icon('Microsoft')).to include('fa fa-windows')
    end
  end
end
