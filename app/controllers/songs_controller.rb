class SongsController < ApplicationController
  before_action :load_resource, only: [:show, :update]
  before_action :authenticate_user!, only: [:update]

  def show
    @title = "#{@song.title} - Everchords"
    @chord_lyrics = ChordProParser.new(@song.body)

    @contained_chords = @chord_lyrics.contained_chords.sort.map do |chord|
      #chord_data = ChordService.new(chord).fetch
      #chord_data.dig('uc', 'chord', 0).merge!('original_name' => chord)
      {'original_name' => chord}
    end

  end

  def update
    update_song
    redirect_to song_path(@song.guid)
  end

  private

  def load_resource
    if current_user
      @song = current_user.songs.find_or_initialize_by(id: params[:id])
    elsif params[:secret_token]
      @song = Song.find_by(id: params[:id], secret_token: params[:secret_token])
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def update_song
    evernote_note = evernote_service.note(params['id'])
    @song.update_from_evernote(evernote_note)
    @song.user = current_user
    @song.save!
  end
end
