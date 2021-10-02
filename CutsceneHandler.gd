extends Node

onready var game_state = GameState

signal show_text_dialog(text)
signal hide_dialog()
signal move_spaceship()

func _ready():
	game_state.connect("game_stage_changed", self, "select_and_play_cutscene")

func select_and_play_cutscene(game_stage, stage_type):
	if game_state.STAGE_TYPE.CUTSCENE == stage_type:
		print("We have a cutscene: ", game_stage)
		#emit_signal("move_spaceship")
		match game_stage:
			game_state.GAME_STAGE.INTRO:
				print("Intro")
				emit_signal("show_text_dialog", "We have incoming bogies captain!")
			game_state.GAME_STAGE.CUT_TO_L2:
				emit_signal("show_text_dialog", "Oh no! Asteroid belt ahead! Brace yourselves!")


func _on_DialogTimer_timeout():
	emit_signal("hide_dialog")
	match game_state.current_game_stage: 
		game_state.GAME_STAGE.INTRO:
			game_state.change_game_stage(game_state.GAME_STAGE.LEVEL1)
		game_state.GAME_STAGE.CUT_TO_L2:
			game_state.change_game_stage(game_state.GAME_STAGE.LEVEL2)
