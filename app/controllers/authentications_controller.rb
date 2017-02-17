class AuthenticationsController < ApplicationController
  before_action :set_authentication, only: [:show, :destroy]

  def index
    @authentications = policy_scope(Authentication.all)
  end

  def show
    authorize @authentication, :show?
  end

  # DELETE /authentications/:id
  # DELETE /authentications/:id.json
  def destroy
    authorize @authentication, :destroy?
    user = @authentication.user
    provider = @authentication.provider
    @authentication.destroy!
    respond_to do |format|
      format.html { redirect_to edit_user_path(user), success: t('controllers.authentications.destroy.success', provider: provider.titleize) }
      format.json { head :no_content }
    end
  end

  private

  def set_authentication
    @authentication = Authentication.find(params[:id])
  end

  def user_not_authorized
    if current_user
      redirect_to edit_user_path(current_user), error: t('controllers.authentications.user_not_authorized.user')
    else
      redirect_to root_path, error: t('controllers.authentications.user_not_authorized.guest')
    end
  end

  def record_not_found
    skip_auth
    if current_user
      redirect_to edit_user_path(current_user), error: t('controllers.authentications.record_not_found')
    else
      redirect_to root_path, error: t('controllers.authentications.record_not_found')
    end
  end
end
