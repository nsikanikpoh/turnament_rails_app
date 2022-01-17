class Group < ApplicationRecord
    belongs_to :game_turnament
    validates_presence_of :name
end
