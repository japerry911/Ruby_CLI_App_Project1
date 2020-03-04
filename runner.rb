require_relative "./config/environment"

system("clear")

valid_user = login

cli_game = CLI.new(valid_user)
cli_game.cli_instance 