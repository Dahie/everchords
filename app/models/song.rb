# frozen_string_literal: true

class Song < ApplicationRecord
  extend FriendlyId
  include SongStateMachine
  friendly_id :title, use: :slugged

  belongs_to :user
  belongs_to :notebook

  validates :user, presence: true
  validates :title, presence: true
  validates :body, presence: true
  validates :secret_token, presence: true

  before_validation :set_secret_token

  scope :by_title, -> { order(:title) }

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
    @album ||= meta_string_value('album')
  end

  def year
    @year ||= meta_number_value('year')
  end

  def tempo
    @tempo ||= meta_number_value('tempo')
  end

  def key
    @key ||= meta_string_value('key')
  end

  def capo
    @capo ||= meta_number_value('capo')
  end

  def share_url
    "/songs/#{friendly_id}?secret_token=#{self.secret_token}"
  end

  def evernote_url
    return "https://www.evernote.com/client/web#?b=#{guid}&" if Rails.env.production?

    "https://sandbox.evernote.com/Home.action#n=#{guid}&s=s1&ses=4&sh=2&sds=5&"
  end

  def key_url
    "http://www.piano-keyboard-guide.com/key-of-#{verbose_key}.html"
  end

  VERBOSE_KEY_MAPPING = {
    'Ab' => 'a-flat',
    'Am' => 'a-minor',
    'A#' => 'a-sharp',
    'A#m' => 'a-sharp-minor',
    'Bb' => 'b-flat',
    'Bm' => 'b-minor',
    'Bbm' => 'b-flat-minor',
    'Cm' => 'c-minor',
    'C#' => 'c-sharp',
    'C#m' => 'c-sharp-minor',
    'Db' => 'd-flat',
    'Dbm' => 'd-flat-minor',
    'Dm' => 'd-minor',
    'D#' => 'd-sharp',
    'D#m' => 'd-sharp-minor',
    'Eb' => 'e-flat',
    'Ebm' => 'e-flat-minor',
    'Em' => 'e-minor',
    'Fm' => 'f-minor',
    'F#' => 'f-sharp',
    'F#m' => 'f-sharp-minor',
    'Gb' => 'g-flat',
    'Gbm' => 'g-flat-minor',
    'Gm' => 'g-minor',
    'G#' => 'g-sharp',
    'G#m' => 'g-sharp-minor'
  }.freeze

  def verbose_key
    VERBOSE_KEY_MAPPING.fetch(key, key)&.downcase
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

  private

  def meta_string_value(key_name)
    plain_text.scan(/@#{key_name}=(.+)/).flatten.last
  end

  def meta_number_value(key_name)
    plain_text.scan(/@#{key_name}=(\d+)/).flatten.last
  end
end
