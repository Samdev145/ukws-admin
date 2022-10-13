class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
   if request.env['omniauth.auth'][:provider] == 'google_oauth2'
      info = {
        email: request.env['omniauth.auth']['extra'][:id_info][:email],
        token: request.env['omniauth.auth'][:credentials][:token],
        refresh_token: request.env['omniauth.auth'][:credentials][:refresh_token],
        expires_at: (Time.now.to_i + request.env['omniauth.auth'][:credentials][:expires_at].to_i)
      }

      session[:google] = info
    end

    if request.env['omniauth.auth'][:provider] == 'zoho'
      session[:zoho] = request.env['omniauth.auth'].info
    end

    redirect_to :root
  end
end
