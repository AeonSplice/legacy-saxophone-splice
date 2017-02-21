class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def new
    redirect_back fallback_location: root_path, error: t('controllers.sessions.new.already_logged_in') and return if current_user
  end

  def create
    if @user = login(params[:login], params[:password])
      previous_url = session[:return_to_url].present? ? session[:return_to_url] : root_path
      redirect_to previous_url, success: t('controllers.sessions.create.success')
    else
      flash.now[:error] = t('controllers.sessions.create.failure')
      @login = params[:login]
      render :new
    end
  end

  def destroy
    if current_user
      logout
      redirect_to root_path, success: t('controllers.sessions.destroy.success')
    else
      redirect_to root_path, error: t('controllers.sessions.destroy.failure')
    end
  end
end
