class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def evernote_service
    @evernote_service ||= EvernoteService.new(current_user.evernote_token)
  end
end
