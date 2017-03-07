class SongsController < ApplicationController
  def show
    @songs = enutils.notes(notebook: 'Songbook', limit: 50)
    @song = Song.find_or_initialize_by(guid: params['id'])
    if @song.new_record? || @song.updated_at < 3.days.ago
      update_song
    end

    @title = "#{@song.title} - #{@title}"
    @chord_lyrics = ChordProParser.new(@song.body)
  end

  def update
    @song = Song.find_or_initialize_by(guid: params['id'])
    update_song
  end

  private

  def update_song
    evernote_note = enutils.notestore.getNote(current_user.evernote_token, params['id'], true, true, false, false)
    @song.update_from_evernote(evernote_note)
    @song.user = current_user
    @song.save!
  end
end
