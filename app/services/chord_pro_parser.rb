class ChordProParser

  attr_reader :chord_pro_text

  def initialize(chord_pro_text)
    @chord_pro_text = chord_pro_text
  end

  SUBSTITUTIONS = {
      'b' => '♭',
      '#' => '♯',
      'aug' => '+',
      'dim' => '°',
      '2' => '²',
      '4' => '⁴',
      '5' => '⁵',
      '6' => '⁶',
      '7' => '⁷',
      '9' => '⁹',
      'sus' => 'ˢᵘˢ'
    }.freeze

  def contained_chords
    @contained_chords ||= @chord_pro_text.scan(/\[(\S+?)\]/).flatten.uniq
  end

  def columns_count
    @chord_pro_text.scan(/(?=\{colb\})/).count + 1
  end

  CHORD_ALIASES = {
    'A#': 'Bb',
    'Db': 'C#',
    'D#': 'Eb',
    'Gb': 'F#',
    'Ab': 'G#'
  }.freeze

  def to_html
    html_output = chord_pro_text.dup
    html_output.gsub!(/\[Riff([\S\s]+?)\]/, '<kbd>Riff \1</kbd>')
    html_output.gsub!(/\[(\S+?)\]/, '<kbd>\1</kbd>')
    html_output.gsub!(/\{colb\}/, '<span class="column-break">')

    # reference http://www.onsongapp.com/docs/features/formats/chordpro/
    html_output.gsub!(/\{title:([\S\s]+?)\}/, '<h2 class="title">\1</h2>')
    html_output.gsub!(/\{t:([\S\s]+?)\}/, '<h2 class="title">\1</h2>')
    html_output.gsub!(/\{artist:([\S\s]+?)\}/, '<div class="artist">\1</d>')
    html_output.gsub!(/\{a:([\S\s]+?)\}/, '<div class="artist">\1</d>')
    html_output.gsub!(/\{album:([\S\s]+?)\}/, '<div class="album">\1</div>')
    html_output.gsub!(/\{time:([\S\s]+?)\}/, '<div class="time">\1</div>')
    html_output.gsub!(/\{tempo:([\S\s]+?)\}/, '<div class="tempo">\1</div>')
    html_output.gsub!(/\{capo:([\S\s]+?)\}/, '<div class="capo">\1</div>')
    html_output.gsub!(/\{album:([\S\s]+?)\}/, '<div class="album">\1</div>')


    html_output.gsub!(/\{comment:([\S\s]+?)\}/, '<span class="comment text-muted">\1</span>')
    html_output.gsub!(/\{c:([\S\s]+?)\}/, '<span class="comment text-muted">\1</span>')
    html_output.gsub!(/\{soc\}([\S\s]+?)\{eoc\}/, '<div class="chorus">\1</div>')
    html_output.gsub!(/\{toc\}([\S\s]+?)\{toc\}/, '<div class="tab">\1</div>')
    #substitute_chords(html_output)
    html_output
  end

  private

  def substitute_chords(html_output)
    regex = /(#{SUBSTITUTIONS.keys.join('|')})/
    html_output.gsub!(regex) { |match| substitutions[match] }
  end
end
