class RemovePublishedFromSongs < ActiveRecord::Migration[6.0]
  def change
    remove_column :songs, :published
  end
end
