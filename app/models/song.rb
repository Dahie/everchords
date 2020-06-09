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

  aasm(column: 'state') do
    state :draft, initial: true
    state :published, :unpublished, :restricted

    event :publish do
      transitions from: [:draft, :unpublished], to: :published
    end

    event :unpublish do
      transitions from: :published, to: :unpublished
    end

    event :restrict do
      transitions from: [:unpublished, :published], to: :restricted
    end
  end

  rails_admin do
    list do
      include_fields :title, :user, :notebook
      field :state, :state
    end

    show do
      include_fields :title, :slug, :guid, :user, :notebook, :secret_token, :body
      field :state, :state
    end
  end

  def update_from_evernote(evernote_note)
    self.body = evernote_note.content
    self.title = evernote_note.title
  end

  def set_secret_token
    self.secret_token ||= Devise.friendly_token.first(8)
  end

  def album
    @album ||= plain_text.scan(/@album=(.+)/).flatten.last
  end

  def year
    @year ||= plain_text.scan(/@year=(\d+)/).flatten.last
  end

  def capo
    @capo ||= plain_text.scan(/@capo=(\d+)/).flatten.last
  end

  def share_url
    "/songs/#{friendly_id}?secret_token=#{self.secret_token}"
  end

  def evernote_url
    "https://sandbox.evernote.com/Home.action#n=#{guid}&s=s1&ses=4&sh=2&sds=5&"
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
