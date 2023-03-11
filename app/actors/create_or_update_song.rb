# frozen_string_literal: true

class CreateOrUpdateSong < Actor
  input :user, type: User
  input :evernote_note
  input :notebook, type: Notebook

  def call
    song.update_from_evernote(evernote_note)
    song.user = user
    song.notebook = notebook
    song.save!
  end

  private

  def song
    @song ||= Song.find_or_initialize_by(guid: evernote_note.guid)
  end
end
