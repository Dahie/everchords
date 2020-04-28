# frozen_string_literal: true

class Song < ApplicationRecord
  include AASM

  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user
  belongs_to :notebook

  validates :user, presence: true
  validates :title, presence: true
  validates :body, presence: true
  validates :secret_token, presence: true

  before_validation :set_secret_token

  scope :by_title, -> { order(:title) }

  def update_from_evernote(evernote_note)
    self.body = evernote_note.content
    self.title = evernote_note.title
  end

  def set_secret_token
    self.secret_token ||= Devise.friendly_token.first(8)
  end

  def share_url
    "/songs/#{friendly_id}?secret_token=#{self.secret_token}"
  end

  def plain_text
    @plain_text ||= HtmlToPlainText.plain_text(body)
  end

  def chords
    plain_text.scan(/\[(\S+?)\]/).flatten.uniq
  end

  def song_pro
    @song_pro ||= SongPro.parse(plain_text)
  end
end
