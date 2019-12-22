# frozen_string_literal: true

class AddVisibilityToSongs < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :published, :boolean, default: false
    add_column :songs, :secret_token, :string
  end
end
