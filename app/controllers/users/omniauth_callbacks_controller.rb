# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def evernote
      if user.save
        flash.notice = success_message
        sign_in_and_redirect user
      else
        flash.alert = failure_message(user)
        redirect_to new_user_session_url
      end
    end

    private

    def user
      @user ||= User.from_omniauth(request.env['omniauth.auth'])
    end

    def success_message
      t('devise.omniauth_callbacks.success',
        kind: 'evernote',
        reason: 'you are not enabled')
    end

    def failure_message(user)
      t('devise.omniauth_callbacks.failure',
        kind: 'evernote',
        reason: user.errors.messages.to_s)
    end
  end
end
