class OauthController < ApplicationController
  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    if current_user
      sorcery_fetch_user_hash(provider)
      unless Authentication.where(provider: provider, uid: @user_hash[:uid]).any?
        add_provider_to_user(provider)
        redirect_to edit_user_path(current_user), success: "Added #{provider.titleize} to your oauth credentials."
      else
        redirect_to edit_user_path(current_user), error: "These #{provider.titleize} credentials are already being used, try logging in instead."
      end
    else
      if @user = login_from(provider)
        if @user.activated?
          redirect_to root_path, success: "Logged in via #{provider.titleize}"
        else
          logout
          reset_session
          redirect_to root_path, error: "Please activate your account before logging in via #{provider.titleize}"
        end
      else
        begin
          sorcery_fetch_user_hash(provider)
          @user = build_from(provider)
          session[:provider] = provider
          session[:uid] = @user_hash[:uid]
          render :provider_signup
        rescue => error
          redirect_to root_path, error: "Failed to login via #{provider.titleize}"
        end # End Try/Catch Block
      end # End Login/Register Block
    end # End User/Visiter Block
  end # End Callback Function

  def provider_signup
    @user = User.new user_params
    @auth = Authentication.new user: @user,
                               provider: session[:provider],
                               uid: session[:uid]

    ApplicationRecord.transaction do
      if user_params[:password].empty? && user_params[:password_confirmation].empty?
        @user.bypass_password = true
        @user.setup_activation
      end

      if recaptcha_passed(@user) && @user.save && @auth.save
        byebug
        reset_session
        redirect_to root_path, success: 'Account created, check your email for your activation link.'
      else
        # Don't leak auth information if user has validation errors
        @auth = nil
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def auth_params
    params.permit(:provider, :code)
  end
end
