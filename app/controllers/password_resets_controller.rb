class PasswordResetsController < ApplicationController
  skip_before_filter :require_login

  before_action :set_user_and_token, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email(params[:email])
    @user = User.new email: params[:email] if @user.nil?
    if recaptcha_passed?(@user)
      @user.deliver_reset_password_instructions! unless @user.new_record?
      redirect_to root_path, success: t('controllers.password_resets.create.success')
    else
      render :new
    end
  end

  def edit
  end

  def update
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password!(params[:user][:password])
      redirect_to root_path, success: t('controllers.password_resets.update.success')
    else
      render :edit
    end
  end

  private

  def set_user_and_token
    @token = params[:token]
    @user = User.load_from_reset_password_token(params[:token])

    redirect_to root_path, error: t('controllers.password_resets.invalid_token') unless @token.present? && @user.present?
  end
end
