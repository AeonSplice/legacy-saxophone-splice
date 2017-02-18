require 'rails_helper'

RSpec.describe AuthenticationPolicy do
  subject { described_class.new(user, authentication) }

  let(:resolved_scope) do
    described_class::Scope.new(user, Authentication.all).resolve
  end

  context 'for a visitor' do
    let(:user) { nil }
    let(:authentication) { create :authentication }

    it { is_expected.to forbid_action(:destroy) }
  end

  context 'for a user' do
    let(:user) { create :user }

    context 'without auth' do
      let(:authentication) { create :authentication }

      it 'excludes auth from resolved scope' do
        pending 'scope implementation'
        expect(resolved_scope).not_to include(authentication)
      end

      it { is_expected.to forbid_action(:destroy) }
    end

    context 'with auth' do
      let(:authentication) { create :authentication, user: user }

      it 'includes auth in resolved scope' do
        expect(resolved_scope).to include(authentication)
      end

      it { is_expected.to permit_action(:destroy) }
    end
  end
end
