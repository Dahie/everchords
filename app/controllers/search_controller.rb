class SearchController < ApplicationController
  def show
    render(plain: 'Not Authorized', status: :unauthorized) and return true unless current_user

    results = {}
    current_user.notebooks.each do |notebook|
      results[notebook.id] = { name: notebook.name, results: notebook.songs.where('lower(title) LIKE ?', "%#{params[:query].downcase}%").map do |song|
                                                               { title: song.title, url: user_song_path(song.user, song) }
                                                             end }
    end

    body = {
      results:
    }
    render json: body.to_json
  end
end
