class AuthenticationsController < ApplicationController
  before_action :set_authentication, only: [:destroy]

  # DELETE /authentications/:id
  # DELETE /authentications/:id.json
  def destroy
    authorize @authentication, :destroy?
    user = @authentication.user
    provider = @authentication.provider
    @authentication.destroy
    respond_to do |format|
      format.html { redirect_to edit_user_path(user), success: "Successfully removed #{provider.titleize} from your account."}
      format.json { head :no_content }
    end
  end

  private

  def set_authentication
    @authentication = Authentication.find(params[:id])
  end

  def user_not_authorized
    if current_user
      redirect_to edit_user_path(current_user), error: 'You don\'t have permission to remove that authentication.'
    else
      redirect_to root_path, error: 'You don\'t have permission to remove that authentication.'
    end
  end

  def record_not_found
    skip_auth
    if current_user
      redirect_to edit_user_path(current_user), error: 'Could not find that authentication.'
    else
      redirect_to root_path, error: 'Could not find that authentication.'
    end
  end
end
