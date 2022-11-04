# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def new
    @adapter = params[:adapter].upcase.constantize
    render :new
  end

  def create
    session[request.env['omniauth.auth'][:provider]] = request.env['omniauth.auth'].info

    redirect_to :root
  end
end
