class Notebook < ApplicationRecord
  belongs_to :user
  has_many :songs, dependent: :destroy

  def update_notes(evernote_notes)
    evernote_notes.each do |evernote_note|
      song = Song.find_or_initialize_by(guid: evernote_note.guid)
      song.update_from_evernote(evernote_note)
      song.user = user
      song.notebook = self
      song.save!
    end
  end
end
