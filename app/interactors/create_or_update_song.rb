# frozen_string_literal: true

class CreateOrUpdateSong
  include Interactor

  delegate :user, :notebook, :evernote_note, to: :context

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
