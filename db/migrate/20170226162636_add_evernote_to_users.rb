# frozen_string_literal: true

class AddEvernoteToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :username, :string
    add_column :users, :avatar, :string
    rename_column :users, :uuid, :uid
  end
end
