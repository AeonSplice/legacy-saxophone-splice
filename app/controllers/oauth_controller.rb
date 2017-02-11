class OauthController < ApplicationController
  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    if current_user
      unless current_user.authentications.where(provider: provider).any?
        add_provider_to_user(provider)
        redirect_to edit_user_path(current_user), success: "Added #{provider.titleize} to your oauth credentials."
      else
        redirect_to edit_user_path(current_user), error: "You already have credentials for #{provider.titleize}."
      end
    else
      if @user = login_from(provider)
        redirect_to root_path, success: "Logged in via #{provider.titleize}"
      else
        begin
          @user = create_and_validate_from(provider)
          redirect_to signup_path, notice: 'Please finish' and return unless @user
          @user.activate!

          reset_session
          auto_login(@user)
          redirect_to root_path, success: "Registered via #{provider.titleize}"
        rescue => error
          redirect_to root_path, error: "Failed to login via #{provider.titleize}"
        end # End Try/Catch Block
      end # End Login/Register Block
    end # End User/Visiter Block
  end # End Callback Function

  private

  def auth_params
    params.permit(:provider, :code)
  end
end
