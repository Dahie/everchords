# frozen_string_literal: true

class RemovePublishedFromSongs < ActiveRecord::Migration[6.0]
  def change
    remove_column :songs, :published # rubocop:disable Rails/ReversibleMigration
  end
end
