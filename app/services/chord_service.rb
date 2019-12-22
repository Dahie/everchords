# frozen_string_literal: true

class ChordService
  include HTTParty
  base_uri 'ukulele-chords.com'

  ROOT_CHORDS = %w[Ab A Bb B C Db D Eb E F Gb G].freeze
  CHORD_ALIASES = {
    'A#' => 'Bb',
    'C#' => 'Db',
    'D#' => 'Eb',
    'F#' => 'Gb',
    'G#' => 'Ab'
  }.freeze

  attr_accessor :root, :type

  def initialize(chord)
    regex = /(#{CHORD_ALIASES.keys.join('|')})/
    chord.gsub!(regex) { |match| CHORD_ALIASES[match] }

    @root = chord.match(/(#{ROOT_CHORDS.join('|')})/)[1]
    @type = chord.gsub(/(#{ROOT_CHORDS.join('|')})/, '')
    @type = 'major' if @type == ''
    @type = 'minor' if @type == 'm'
  end

  def fetch
    @options = { query: { ak: ENV['UKULELE_CHORDS_TOKEN'], r: root, typ: type } }

    Rails.cache.fetch("#{root}/#{type}", expires_in: 12.days, force: Rails.cache.fetch("#{root}/#{type}").nil?) do
      resp = self.class.get('/get', @options)
      resp
    end
  end
end
