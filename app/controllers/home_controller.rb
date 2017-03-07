class HomeController < ApplicationController
  def index
    if current_user&.evernote_token
      @songs = enutils.notes(notebook: 'Songbook', limit: 50)
    else
      @songs = []
    end
  end
end
