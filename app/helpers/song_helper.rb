# frozen_string_literal: true

module SongHelper
  def build_line(line)
    content_tag :p do
      line.parts.collect do |part|
        html = ''
        html += content_tag(:kbd, part.chord) if part.chord.present?
        html += part.lyric
        html
      end.join.html_safe
    end
  end
end
