# frozen_string_literal: true

require 'song_pro'

class SongsController < ApplicationController
  before_action :load_resource, only: %i[show update]
  before_action :authenticate_user!, only: [:update]

  def show
    @fretboards = [Fretboard.create_for_bass, Fretboard.create_for_ukulele]
    render :not_found unless @song
  end

  def update
    CreateOrUpdateSong.call(evernote_note:,
                            user: current_user,
                            notebook: @song.notebook)
    redirect_to user_song_path(@song)
  end

  def publish
    @song.publish!
  end

  def unpublish; end

  private

  def load_resource
    @song = Song.find_by(slug: params[:id], secret_token: params[:secret_token]) ||
            current_user&.songs&.find_by(slug: params[:id]) ||
            Song.published.find_by(slug: params[:id])
  end

  def evernote_note
    evernote_service.note(@song.guid)
  end
end
