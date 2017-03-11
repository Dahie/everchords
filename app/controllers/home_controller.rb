class HomeController < ApplicationController
  def index
    if current_user&.evernote_token
      @original_songs = evernote_service.notes('Songbook Originals')
      @songs = evernote_service.notes('Songbook')
    else
      @original_songs = []
      @songs = []
    end
  end
end
