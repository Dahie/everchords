class SongsController < ApplicationController
  def show
    @songs = enutils.notes(notebook: 'Songbook', limit: 50)
    @song = Song.find_or_initialize_by(guid: params['id'])
    if @song.new_record? || @song.updated_at < 3.days.ago
      update_song
    end

    @title = "#{@song.title} - Everchords"
    @chord_lyrics = ChordProParser.new(@song.body)

    @contained_chords = @chord_lyrics.contained_chords.sort.map do |chord|
      #chord_data = ChordService.new(chord).fetch
      #chord_data.dig('uc', 'chord', 0).merge!('original_name' => chord)
      {'original_name' => chord}
    end

  end

  def update
    @song = Song.find_or_initialize_by(guid: params['id'])
    update_song
    redirect_to song_path(@song.guid)
  end

  private

  def update_song
    evernote_note = enutils.notestore.getNote(current_user.evernote_token, params['id'], true, true, false, false)
    @song.update_from_evernote(evernote_note)
    @song.user = current_user
    @song.save!
  end
end
