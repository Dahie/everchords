class HomeController < ApplicationController
  def index
    if current_user&.evernote_token
      @original_songs = enutils.notes(notebook: 'Songbook Originals', limit: 50)
      @songs = enutils.notes(notebook: 'Songbook', limit: 50)
    else
      @original_songs = []
      @songs = []
    end
  end
end
