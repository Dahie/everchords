# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def evernote
    auth = request.env['omniauth.auth']

    user = User.from_omniauth(request.env['omniauth.auth'])
    if user.save
      flash.notice = t('devise.omniauth_callbacks.success', kind: 'evernote', reason: 'you are not enabled')
      sign_in_and_redirect user
    else
      flash.alert = t('devise.omniauth_callbacks.failure', kind: 'evernote', reason: user.errors.messages.to_s)
      redirect_to new_user_session_url
    end
  end
end
