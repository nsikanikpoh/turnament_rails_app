class GameTurnamentsController < ApplicationController
  before_action :set_game_turnament, only: %i[ show edit update destroy matches group_game play_off final ]

  # GET /game_turnaments or /game_turnaments.json
  def index
    @game_turnaments = GameTurnament.all.order(created_at: :desc)
  end

  # GET /game_turnaments/1 or /game_turnaments/1.json
  def show
    group_games
    if @game_turnament.status == "done"
      @winner = Team.find(@game_turnament.winner_id)
      @finalist = Team.find(@game_turnament.finalist_id)
    end
  end

  # GET /game_turnaments/new
  def new
    @teams = Team.all
    @game_turnament = GameTurnament.new
  end

  # GET /game_turnaments/1/edit
  def edit
  end

  def group_game
    GroupGameService.new(@game_turnament.id).play_group_game
    respond_to do |format|
      if @game_turnament.update(status:"in_progress", progress:"play-off-stage")
        format.html { redirect_to game_turnament_url(@game_turnament), notice: "Turnament is in progress." }
        format.json { render :show, status: :ok, location: @game_turnament }
      else
        format.html { redirect_to game_turnament_url(@game_turnament), notice: "problem playing play group stages." }
        format.json { render :show, status: 400, location: @game_turnament }
      end
    end
  end

  def play_off
    PlayOffService.new(@game_turnament.id).play_play_off_game
    respond_to do |format|
      if @game_turnament.update(progress:"final-stage")
        format.html { redirect_to game_turnament_url(@game_turnament), notice: "Turnament play-off completed." }
        format.json { render :show, status: :ok, location: @game_turnament }
      else
        format.html { redirect_to game_turnament_url(@game_turnament), notice: "problem playing play off." }
        format.json { render :show, status: 400, location: @game_turnament }
      end
    end
  end

  def final
    result = PlayFinalService.new(@game_turnament.id).play_final_game
    respond_to do |format|
      if @game_turnament.update(finalist_id: result[1], winner_id: result[0], status: "done", progress:"completed")
        format.html { redirect_to game_turnament_url(@game_turnament), notice: "Turnament finals completed." }
        format.json { render :show, status: :ok, location: @game_turnament }
      else
        format.html { redirect_to game_turnament_url(@game_turnament), notice: "problem playing final." }
        format.json { render :show, status: 400, location: @game_turnament }
      end
    end
  end

  # POST /game_turnaments or /game_turnaments.json
  def create
    @game_turnament = GameTurnament.new(game_turnament_params)  
    @teams = Team.all  
    @game_turnament.status = "draft"
    @game_turnament.progress = "group-stage"
    logger.info "params #{game_turnament_params[:team_ids].inspect}"
    respond_to do |format|
      if @game_turnament.save
        AssignTeamService.new(game_turnament_params[:team_ids], @game_turnament.id).process_team_ids
        format.html { redirect_to game_turnament_url(@game_turnament), notice: "Turnament was successfully created." }
        format.json { render :show, status: :created, location: @game_turnament }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game_turnament.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_turnaments/1 or /game_turnaments/1.json
  def update
    respond_to do |format|
      if @game_turnament.update(game_turnament_params)
        format.html { redirect_to game_turnament_url(@game_turnament), notice: "Turnament was successfully updated." }
        format.json { render :show, status: :ok, location: @game_turnament }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game_turnament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_turnaments/1 or /game_turnaments/1.json
  def destroy
    @game_turnament.destroy
    respond_to do |format|
      format.html { redirect_to game_turnaments_url, notice: "Turnament was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def matches
    group_games
    group_a_team_ids = @groupa.team_ids.split(',').map(&:to_i)
    group_b_team_ids = @groupb.team_ids.split(',').map(&:to_i)
    @matches = Game.where(game_turnament_id: @game_turnament.id)
    @groupa_m =  @matches.select{|m| m.progress == "group-stage" && group_a_team_ids.include?(m.team_a_id) && group_a_team_ids.include?(m.team_b_id) }                 
    @groupb_m =  @matches.select{|m| m.progress == "group-stage" && group_b_team_ids.include?(m.team_a_id) && group_b_team_ids.include?(m.team_b_id) }
    
    @groupa_matches = []                   
     @groupa_m.each do |m| 
      @groupa_matches <<  { "team_a" => @group_a_teams.select{|t| t.id == m.team_a_id}[0], "team_b" => @group_a_teams.select{|t| t.id == m.team_b_id}[0], 
        "team_a_score" => m.team_a_score, "team_b_score" => m.team_b_score, "progress" => m.progress }
    end

    @groupb_matches = []                   
     @groupb_m.each do |m| 
      @groupb_matches <<  { "team_a" => @group_b_teams.select{|t| t.id == m.team_a_id}[0], "team_b" => @group_b_teams.select{|t| t.id == m.team_b_id}[0], 
        "team_a_score" => m.team_a_score, "team_b_score" => m.team_b_score, "progress" => m.progress }
    end

    @all_teams = @group_a_teams + @group_b_teams
    @play_off_m =  @matches.select{|m| m.progress == "play-off-stage"}
    
    @play_off_matches = []
    @play_off_m.each do |m| 
      @play_off_matches <<  { "team_a" => @all_teams.select{|t| t.id == m.team_a_id}[0], "team_b" => @all_teams.select{|t| t.id == m.team_b_id}[0], 
        "team_a_score" => m.team_a_score, "team_b_score" => m.team_b_score, "progress" => m.progress }
    end

    @final_m =  @matches.select{|m| m.progress == "final-stage"}
    
    @final_matches = []
     @final_m.each do |m| 
      @final_matches <<  { "team_a" => @all_teams.select{|t| t.id == m.team_a_id}[0], "team_b" => @all_teams.select{|t| t.id == m.team_b_id}[0], 
        "team_a_score" => m.team_a_score, "team_b_score" => m.team_b_score, "progress" => m.progress }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_turnament
      @game_turnament = GameTurnament.find(params[:id])
    end

   def group_games
    groups = Group.where(game_turnament_id: @game_turnament.id)
    @groupa = groups.select{|g| g.name == "A"}[0]
    @groupb = groups.select{|g| g.name == "B"}[0]
    @group_a_teams = Team.where('id IN (?)', @groupa.team_ids.split(',').map(&:to_i))
    @group_b_teams = Team.where('id IN (?)', @groupb.team_ids.split(',').map(&:to_i))
   end


    # Only allow a list of trusted parameters through.
    def game_turnament_params
      params.require(:game_turnament).permit(:name, team_ids:[])
    end
end
