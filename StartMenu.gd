extends Control

onready var game_state = GameState

func _on_StartBtn_pressed():
	game_state.change_game_stage(game_state.GAME_STAGE.INTRO)
	get_tree().change_scene("res://World.tscn")
