class AddStateToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :state, :string, default: 'draft'
  end
end
