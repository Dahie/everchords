class HomeController < ApplicationController
  def index
    if current_user&.evernote_token
      #current_user.notebooks(&:update_from_evernote)
    else
      @original_songs = []
      @songs = []
    end
  end
end
