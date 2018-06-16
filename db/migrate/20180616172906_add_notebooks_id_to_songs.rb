class AddNotebooksIdToSongs < ActiveRecord::Migration[5.2]
  def change
    add_column :songs, :notebook_id, :integer
    add_index :songs, :notebook_id
  end
end
