class PlayFinalService
    attr_reader :game_turnament_id
  
    def initialize(game_turnament_id)
      @game_turnament_id = game_turnament_id
    end
  
    def play_final_game
      groups = Group.where(game_turnament_id: @game_turnament_id)
      matches = Game.where(progress:"play-off-stage", game_turnament_id: @game_turnament_id)
      winners = []
      matches.each do |m|
         if m.team_a_score > m.team_b_score
            winners << m.team_a_id
         else
            winners << m.team_b_id
         end
      end
        #first play off
        play_final = matchScore()
          game = Game.create!(
                team_a_id:winners[0], 
                team_b_id:winners[1],
                team_a_score:play_final[0],
                team_b_score:play_final[1],
                game_turnament_id: @game_turnament_id,
                level:"Play Off Stage",
                progress:"final-stage"
              )
        #finalize turnament
        return finalise_turnament(game)
 end
  
    private 

    def finalise_turnament(game)
       final_winner = 0
       finalist = 0
       if game.team_a_score > game.team_b_score
            final_winner = game.team_a_id
            finalist = game.team_b_id
       else
            final_winner = game.team_b_id
            finalist = game.team_a_id
       end
      [final_winner, finalist]
    end
  
    def matchScore
  
      rndInt1 = Random.rand(1..5)
      rndInt12 = Random.rand(1..5)
        # here there must be a winner
      while rndInt1 == rndInt12 
          rndInt12 = Random.rand(1..5)
      end
      [rndInt1, rndInt12]
    end 
  
  end