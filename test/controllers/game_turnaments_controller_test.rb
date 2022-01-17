require 'test_helper'

class GameTurnamentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game_turnament = game_turnaments(:one)
  end

  test "should get index" do
    get game_turnaments_url
    assert_response :success
  end

  test "should get new" do
    get new_game_turnament_url
    assert_response :success
  end

  test "should create game_turnament" do
    assert_difference('GameTurnament.count') do
      post game_turnaments_url, params: { game_turnament: { finalist_id: @game_turnament.finalist_id, name: @game_turnament.name, status: @game_turnament.status, winner_id: @game_turnament.winner_id } }
    end

    assert_redirected_to game_turnament_url(GameTurnament.last)
  end

  test "should show game_turnament" do
    get game_turnament_url(@game_turnament)
    assert_response :success
  end

  test "should get edit" do
    get edit_game_turnament_url(@game_turnament)
    assert_response :success
  end

  test "should update game_turnament" do
    patch game_turnament_url(@game_turnament), params: { game_turnament: { finalist_id: @game_turnament.finalist_id, name: @game_turnament.name, status: @game_turnament.status, winner_id: @game_turnament.winner_id } }
    assert_redirected_to game_turnament_url(@game_turnament)
  end

  test "should destroy game_turnament" do
    assert_difference('GameTurnament.count', -1) do
      delete game_turnament_url(@game_turnament)
    end

    assert_redirected_to game_turnaments_url
  end
end
