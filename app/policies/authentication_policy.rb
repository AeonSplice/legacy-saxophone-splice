class AuthenticationPolicy < ApplicationPolicy
  def destroy?
    (@user == @record.user &&
      # Prevent users from removing their last auth if they don't have a password
      (@user.crypted_password.present? || @user.authentications.where.not(id: @record.id).any?)
    )
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
