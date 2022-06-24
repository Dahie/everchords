# frozen_string_literal: true

class Fretboard
  attr_reader :name, :strings, :fret_count, :single_dots, :double_dots

  def initialize(name, fret_count, strings, single_dots, double_dots)
    @name = name
    @fret_count = fret_count
    @strings = strings
    @single_dots = single_dots
    @double_dots = double_dots
  end

  def self.create_for_ukulele
    new('Ukulele', 17,
        %w[A E C G],
        [5, 7, 10, 15],
        [12])
  end

  def self.create_for_bass
    new('Bass', 25,
        %w[G D A E],
        [3, 5, 7, 9, 15, 17, 19, 21],
        [12, 24])
  end

  def dots
    single_dots + double_dots
  end

  def any_dots_at?(index)
    index.in?(dots)
  end

  def single_dot_at?(index)
    index.in?(single_dots)
  end

  def double_dots_at?(index)
    index.in?(double_dots)
  end
end
