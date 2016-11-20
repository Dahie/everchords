class HomeController < ApplicationController
  def index
    if authtoken
      @songs = enutils.notes(notebook: 'Songbook', limit: 50)
    end
  end
end
