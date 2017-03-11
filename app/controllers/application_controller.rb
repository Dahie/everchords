class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def evernote_service
    @evernote_service ||= EvernoteService.new(current_user.evernote_token)
  end
end
