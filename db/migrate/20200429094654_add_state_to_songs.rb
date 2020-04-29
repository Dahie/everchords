class AddStateToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :state, default: 'draft'
    end
  end
end
