class SessionsController < ApplicationController
  def new
    redirect_back fallback_location: root_path, error: 'Already logged in.' and return if current_user
    @user = User.new
    session[:return_to] = request.referrer unless session[:return_to]
  end

  def create
    if @user = login(params[:login], params[:password])
      flash[:success] = 'Login successful!'
      if session[:return_to]
        redirect_to session[:return_to]
        session[:return_to] = nil
      else
        redirect_to root_path
      end
    else
      flash.now[:error] = 'Incorrect Username / Password combination.'
      @login = params[:login]
      render :new
    end
  end

  def destroy
    if current_user
      logout
      redirect_to root_path, notice: 'Logged out!'
    else
      redirect_to root_path, notice: 'Shenanigans!'
    end
  end
end
