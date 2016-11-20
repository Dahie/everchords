class Song < ApplicationRecord
  #belongs_to :user

  #validate :user, presence: true
  validates :title, presence: true
  validates :body, presence: true

  def update_from_evernote(evernote_note)
    self.body = evernote_note.content
    self.title = evernote_note.title
  end
end
