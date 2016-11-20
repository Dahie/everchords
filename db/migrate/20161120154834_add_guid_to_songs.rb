class AddGuidToSongs < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :guid, :string
  end
end
