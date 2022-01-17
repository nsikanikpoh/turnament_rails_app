class AddProgressToGameTurnaments < ActiveRecord::Migration[6.0]
    def change
      add_column :game_turnaments, :progress, :string, default: false   
      add_column :games, :progress, :string, default: false 
    end
  end
  