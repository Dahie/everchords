class LoginController < ApplicationController
  rescue_from OAuth::Unauthorized, :with => Proc.new{redirect_to root_path}

  def callback
    auth_hash = request.env['omniauth.auth']
    puts auth.inspect

    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      flash.notice = t('devise.omniauth_callbacks.success', kind: 'evernote', reason: 'you are not enabled')
      sign_in_and_redirect user
    end
  end

  def evernote
    auth = request.env["omniauth.auth"]
    puts auth.inspect

    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      flash.notice = t('devise.omniauth_callbacks.success', kind: 'evernote', reason: 'you are not enabled')
      sign_in_and_redirect user
    end
  end

  def oauth_failure
    redirect_to root_path
  end

  def logout
    session.clear
    redirect_to root_path
  end

end
