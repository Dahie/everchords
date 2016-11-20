class SongsController < ApplicationController

  def show
    @songs = enutils.notes(notebook: 'Songbook', limit: 50)

    @song = Song.find_or_initialize_by(guid: params['id'])
    if @song.new_record?
      evernote_note = enutils.notestore.getNote(authtoken, params['id'], true, true, false, false)
      @song.update_from_evernote(evernote_note)
      @song.save!
    end

    @title = "#{@song.title} - #{@title}"
    @chord_lyrics = ChordProParser.new(@song.body)
  end

end
