require "application_system_test_case"

class GameTurnamentsTest < ApplicationSystemTestCase
  setup do
    @game_turnament = game_turnaments(:one)
  end

  test "visiting the index" do
    visit game_turnaments_url
    assert_selector "h1", text: "Game Turnaments"
  end

  test "creating a Game turnament" do
    visit game_turnaments_url
    click_on "New Game Turnament"

    fill_in "Finalist", with: @game_turnament.finalist_id
    fill_in "Name", with: @game_turnament.name
    fill_in "Status", with: @game_turnament.status
    fill_in "Winner", with: @game_turnament.winner_id
    click_on "Create Game turnament"

    assert_text "Game turnament was successfully created"
    click_on "Back"
  end

  test "updating a Game turnament" do
    visit game_turnaments_url
    click_on "Edit", match: :first

    fill_in "Finalist", with: @game_turnament.finalist_id
    fill_in "Name", with: @game_turnament.name
    fill_in "Status", with: @game_turnament.status
    fill_in "Winner", with: @game_turnament.winner_id
    click_on "Update Game turnament"

    assert_text "Game turnament was successfully updated"
    click_on "Back"
  end

  test "destroying a Game turnament" do
    visit game_turnaments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Game turnament was successfully destroyed"
  end
end
