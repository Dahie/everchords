# frozen_string_literal: true

class AddVisibilityToSongs < ActiveRecord::Migration[5.0]
  def change
    change_table :songs, bulk: true do |t|
      t.boolean :published, default: false, null: false
      t.string :secret_token
    end
  end
end
