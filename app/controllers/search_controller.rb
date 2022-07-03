# frozen_string_literal: true

class SearchController < ApplicationController
  def show
    render(plain: 'Not Authorized', status: :unauthorized) and return true unless current_user

    body = {
      results: search_results(params[:query])
    }
    render json: body.to_json
  end

  private

  def search_results(query)
    {}.tap do |results|
      current_user.notebooks.each do |notebook|
        results[notebook.id] = {
          name: notebook.name,
          results: notebook_results(query, notebook)
        }
      end
    end
  end

  def notebook_results(query, notebook)
    notebook.songs.where('lower(title) LIKE ?', "%#{query.downcase}%").map do |song|
      { title: song.title,
        url: user_song_path(song.user, song) }
    end
  end
end
