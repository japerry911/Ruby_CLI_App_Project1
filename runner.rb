require_relative "./config/environment"

valid_user = login

cli_game = CLI.new(valid_user)

cli_game.game 