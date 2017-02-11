class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  add_flash_types :error, :success

  rescue_from Pundit::NotAuthorizedError,                 with: :user_not_authorized
  rescue_from ActionController::InvalidAuthenticityToken, with: :session_expired
  rescue_from ActiveRecord::RecordNotFound,               with: :record_not_found

  #####################
  ## Default Methods ##
  #####################

  def user_not_authorized
    if current_user
      redirect_back fallback_location: root_path, error: 'You don\'t have permission to do that.'
    else
      redirect_to login_path, error: 'You don\'t have permission to do that, try logging in first.'
    end
  end

  def session_expired
    redirect_to root_path, error: 'Your session has expired, please log back in.'
  end

  def skip_auth
    skip_authorization
    skip_policy_scope
  end

  def record_not_found
    skip_auth
    redirect_to root_path, error: 'Could not find that record.'
  end

  ######################
  ## Helper Functions ##
  ######################

  def recaptcha_passed(model)
    verify_recaptcha model: model,
                     attribute: :recaptcha,
                     env: Rails.env
  end
end
