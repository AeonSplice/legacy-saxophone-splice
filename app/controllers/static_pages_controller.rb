class StaticPagesController < ApplicationController
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
