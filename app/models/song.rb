class Song < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :notebook

  validates :user, presence: true
  validates :title, presence: true
  validates :body, presence: true
  validates :secret_token, presence: true

  before_validation :set_secret_token

  def update_from_evernote(evernote_note)
    self.body = evernote_note.content
    self.title = evernote_note.title
  end

  def set_secret_token
    self.secret_token ||= Devise.friendly_token.first(8)
  end

  def share_url
    "/songs/#{self.guid}?secret_token=#{self.secret_token}"
  end
end
