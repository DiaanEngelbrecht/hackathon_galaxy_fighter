extends Control


onready var game_state = GameState
onready var cutscene_handler = CutsceneHandler

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameOver.hide()
	$Restart.hide()
	$Dialog.hide()

	game_state.connect("health_changed", self, "update_health_bar")
	game_state.connect("score_increaded", self, "update_score")
	game_state.connect("game_over", self, 'show_text')


	cutscene_handler.connect("hide_dialog", self, 'hide_dialog')
	cutscene_handler.connect("show_text_dialog", self, 'show_text_dialog')

func update_health_bar(new_player_health):
	$TextureRect.texture.region.position.x = (4 - new_player_health) * 80

func update_score(new_score):
	$Score.text = 'Score : ' + String(new_score)

func show_text():
	$GameOver.show()
	$Restart.show()

func _on_Restart_pressed():
	GameState.reset();
	get_tree().reload_current_scene()

func show_text_dialog(text):
	print("Show dialog")
	print("Text to show", text)
	$Dialog/Label.text = text
	$Dialog.show()

func hide_dialog():
	print("Hiding dialog")
	$Dialog.hide()
