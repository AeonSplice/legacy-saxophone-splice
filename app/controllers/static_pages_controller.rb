class StaticPagesController < ApplicationController
  skip_before_action :require_login
  layout 'barebones', only: [:motd]

  def index
  end

  def motd
  end

  def about
  end

  def contact
  end
end
