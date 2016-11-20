class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :authtoken

  def enutils
    @enutils ||= ENUtils::Core.new(authtoken, Rails.env.production?)
  end

  def authtoken
    session[:authtoken]
  end
end
