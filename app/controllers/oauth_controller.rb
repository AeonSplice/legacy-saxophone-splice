class OauthController < ApplicationController
  skip_before_action :require_login

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    if current_user
      sorcery_fetch_user_hash(provider)
      unless Authentication.where(provider: provider, uid: @user_hash[:uid]).any?
        add_provider_to_user(provider)
        redirect_to edit_user_path(current_user), success: t('controllers.oauth.callback.added_provider', provider: provider.titleize)
      else
        redirect_to edit_user_path(current_user), error: t('controllers.oauth.callback.already_used', provider: provider.titleize)
      end
    else
      if @user = login_from(provider)
        if @user.activated?
          redirect_to root_path, success: t('controllers.oauth.callback.logged_in', provider: provider.titleize)
        else
          logout
          reset_session
          redirect_to root_path, error: t('controllers.oauth.callback.activate_first', provider: provider.titleize)
        end
      else
        begin
          sorcery_fetch_user_hash(provider)
          @user = build_from(provider)
          @user.sanitize_timezone
          @user.sanitize_locale
          session[:provider] = provider
          session[:uid] = @user_hash[:uid]
          render :provider_signup
        rescue => e
          logger.error e.message
          redirect_to root_path, error: t('controllers.oauth.callback.failed_to_login', provider: provider.titleize)
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

      if recaptcha_passed?(@user) && @user.save && @auth.save
        reset_session
        redirect_to root_path, success: t('controllers.oauth.provider_signup.success')
      else
        # Don't leak auth information if user has validation errors
        @auth = nil
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:username,
                                 :realname,
                                 :nickname,
                                 :email,
                                 :bio,
                                 :location,
                                 :website,
                                 :locale,
                                 :timezone,
                                 :password,
                                 :password_confirmation)
  end

  def auth_params
    params.permit(:provider, :code)
  end
end
