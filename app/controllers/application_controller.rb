class ApplicationController < ActionController::Base
  ####################
  ## Setup / Config ##
  ####################

  include Pundit
  protect_from_forgery with: :exception
  add_flash_types :error, :success

  ###############################
  ## Default Rescue Statements ##
  ###############################

  rescue_from Pundit::NotAuthorizedError,                 with: :user_not_authorized
  rescue_from ActionController::InvalidAuthenticityToken, with: :session_expired
  rescue_from ActiveRecord::RecordNotFound,               with: :record_not_found

  #####################
  ## Default Actions ##
  #####################

  before_action :set_locale
  before_action :require_login
  around_action :set_timezone, if: :current_user

  #####################
  ## Default Methods ##
  #####################

  def user_not_authorized
    if current_user
      unless request.referrer == login_url
        redirect_back fallback_location: root_path, error: t('controllers.application.user_not_authorized.user')
      else
        redirect_to root_path, error: t('controllers.application.user_not_authorized.user')
      end
    else
      redirect_to login_path, error: t('controllers.application.user_not_authorized.guest')
    end
  end

  def session_expired
    redirect_to root_path, error: t('controllers.application.session_expired')
  end

  def record_not_found
    skip_auth
    redirect_to root_path, error: t('controllers.application.record_not_found')
  end

  def default_url_options
    { locale: I18n.locale }
  end

  ######################
  ## Helper Functions ##
  ######################

  def skip_auth
    skip_authorization
    skip_policy_scope
  end

  def recaptcha_passed?(model)
    verify_recaptcha model: model,
                     attribute: :recaptcha,
                     env: Rails.env
  end

  #####################
  ## Private Methods ##
  #####################

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def set_timezone(&block)
    Time.use_zone(current_user.timezone, &block)
  end
end
