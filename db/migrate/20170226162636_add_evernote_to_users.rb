# frozen_string_literal: true

class AddEvernoteToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :songs, bulk: true do |t|
      t.string :provider
      t.string :username
      t.string :avatar
    end
    rename_column :users, :uuid, :uid
  end
end
