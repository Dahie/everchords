# frozen_string_literal: true

class CreateNotebooks < ActiveRecord::Migration[5.2]
  def change
    create_table :notebooks do |t|
      t.references :user
      t.string :name
      t.index %i[user_id name], unique: 'true'

      t.timestamps
    end
  end
end
