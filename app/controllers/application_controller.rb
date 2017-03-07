class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def enutils
    puts current_user.inspect
    @enutils ||= ENUtils::Core.new(current_user.evernote_token, Rails.env.production?)
  end
end
