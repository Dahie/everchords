# frozen_string_literal: true

require 'song_pro'

class SongsController < ApplicationController
  before_action :load_resource, only: %i[show update]
  before_action :authenticate_user!, only: [:update]

  def show
    @contained_chords = contained_chords
  end

  def update
    CreateOrUpdateSong.call(evernote_note: evernote_note,
                            user: current_user,
                            notebook: @song.notebook)
    redirect_to song_path(@song)
  end

  private

  def contained_chords
    @song.chords.map do |chord|
      #chord_data = ChordService.new(chord).fetch
      #chord_data.dig('uc', 'chord', 0).merge!('original_name' => chord)
      { 'original_name' => chord }
    end
  end

  def load_resource
    if current_user
      @song = current_user.songs.find_or_initialize_by(slug: params[:id])
    elsif params[:secret_token]
      @song = Song.find_by(slug: params[:id], secret_token: params[:secret_token])
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def evernote_note
    evernote_service.note(@song.guid)
  end
end
