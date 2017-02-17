class ErrorsController < ApplicationController
  skip_before_action :require_login

  def show
    skip_auth
    render status_code.to_s, status: status_code
  end

  private

  def status_code
    params[:code] || 500
  end
end
