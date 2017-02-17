require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class.new(user, user_record) }

  let(:resolved_scope) do
    described_class::Scope.new(user, User.all).resolve
  end

  context 'for a visitor' do
    let(:user) { nil }
    let(:user_record) { create :user }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'for a user' do
    let(:user) { create :user }

    context 'on themself' do
      let(:user_record) { user }

      it 'includes user in resolved scope' do
        expect(resolved_scope).to include(user_record)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_edit_and_update_actions }
      it { is_expected.to permit_action(:destroy) }
    end

    context 'on another user' do
      let(:user_record) { create :user }

      it 'excludes auth from resolved scope' do
        expect(resolved_scope).not_to include(user_record)
      end

      it { is_expected.to permit_action(:show) }
      it { is_expected.to forbid_edit_and_update_actions }
      it { is_expected.to forbid_action(:destroy) }
    end
  end

  context 'for an admin' do
    let(:user) { create :admin_user }
    let(:user_record) { create :user }

    it 'includes user in resolved scope' do
      expect(resolved_scope).to include(user_record)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_edit_and_update_actions }
    it { is_expected.to permit_action(:destroy) }
  end
end
