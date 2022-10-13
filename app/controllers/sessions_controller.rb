class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    session[request.env['omniauth.auth'][:provider]] = request.env['omniauth.auth'].info

    redirect_to :root
  end
end
