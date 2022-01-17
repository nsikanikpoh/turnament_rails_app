class AddIndex < ActiveRecord::Migration[6.0]
    def change
      add_index :game_turnaments, :name, unique: true
    end
  end
  