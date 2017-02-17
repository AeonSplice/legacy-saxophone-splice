class UserPolicy < ApplicationPolicy
  def update?
    if @user && @user.has_role?(:admin)
      true
    else
      @user == @record
    end
  end

  def destroy?
    if @user && @user.has_role?(:admin)
      true
    else
      @user == @record
    end
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
