class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def new
    render :new
  end

  def create
    session[request.env['omniauth.auth'][:provider]] = request.env['omniauth.auth'].info

    redirect_to :root
  end
end
