# frozen_string_literal: true

class AddAdminFlagToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :admin, :boolean, default: false, null: false
  end
end
