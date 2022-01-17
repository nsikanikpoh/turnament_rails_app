json.extract! game_turnament, :id, :name, :status, :winner_id, :finalist_id, :created_at, :updated_at
json.url game_turnament_url(game_turnament, format: :json)
