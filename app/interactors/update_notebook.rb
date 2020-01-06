# frozen_string_literal: true

class UpdateNotebook
  include Interactor

  delegate :notebook, to: :context
  delegate :user, to: :notebook
  delegate :evernote_token, to: :user

  def call
    update_songs
    destroy_removed_songs
  end

  private

  def update_songs
    evernote_notes.each do |evernote_note|
      create_or_update_song!(evernote_note)
    end
  end

  def create_or_update_song!(evernote_note)
    CreateOrUpdateSong.call(evernote_note: evernote_note,
                            user: user,
                            notebook: notebook)
  end

  def destroy_removed_songs
    songs_to_remove_from_notebook.destroy_all
  end

  def songs_to_remove_from_notebook
    Song.where(guid: song_guids_removed_in_evernote)
  end

  def song_guids_removed_in_evernote
    existing_song_guids - evernote_guids
  end

  def evernote_guids
    evernote_notes.map(&:guid)
  end

  def existing_song_guids
    notebook.songs.map(&:guid)
  end

  def evernote_notes
    evernote_service.notes(notebook.name)
  end

  def evernote_service
    @evernote_service ||= EvernoteService.new(evernote_token)
  end
end
