class HomeController < ApplicationController
  def index
    if current_user&.evernote_token

    else
      @original_songs = []
      @songs = []
    end
  end
end
