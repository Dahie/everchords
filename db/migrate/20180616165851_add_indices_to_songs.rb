# frozen_string_literal: true

class AddIndicesToSongs < ActiveRecord::Migration[5.2]
  def change
    add_index :songs, :guid
  end
end
