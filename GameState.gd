extends Node


enum GAME_STAGE {START_MENU, INTRO, LEVEL1, CUT_TO_L2, LEVEL2, CUT_TO_B1, BOSS1, GAME_WON, GAME_OVER}
enum STAGE_TYPE {UI, CUTSCENE, PLAYABLE}

export var current_game_stage = GAME_STAGE.START_MENU
var current_stage_type = STAGE_TYPE.UI

var player_health
var score
var high_score
var game_time
var target_play_time

signal game_over
signal score_increaded(new_score)
signal health_changed(new_health)
signal game_stage_changed(game_stage, stage_type)

func reset():
	player_health = 4
	score = 0
	game_time = 0
	target_play_time = 20
	emit_signal("health_changed", player_health)

func _ready():
	player_health = 4
	score = 0
	game_time = 0
	target_play_time = 20

func increase_score(amount_to_increase):
	score += amount_to_increase
	emit_signal('score_increaded', score)

func decrement_health():
	player_health -= 1
	if player_health == 0:
		# Emit player death signal here
		emit_signal("game_over")
	else:
		emit_signal("health_changed", player_health)

func change_game_stage(new_stage):
	current_game_stage = new_stage
	print("Changed game stage to: ", new_stage)
	match new_stage:
		GAME_STAGE.START_MENU, GAME_STAGE.GAME_OVER, GAME_STAGE.GAME_WON:
			current_stage_type = STAGE_TYPE.UI
		GAME_STAGE.INTRO, GAME_STAGE.CUT_TO_L2, GAME_STAGE.CUT_TO_B1:
			current_stage_type = STAGE_TYPE.CUTSCENE
		GAME_STAGE.LEVEL1, GAME_STAGE.LEVEL2, GAME_STAGE.BOSS1:
			current_stage_type = STAGE_TYPE.PLAYABLE
	emit_signal("game_stage_changed", new_stage, current_game_stage)


func _game_time_update():
	if current_stage_type == STAGE_TYPE.PLAYABLE:
		game_time += 1
		if game_time >= target_play_time:
			game_time = 0
			match current_game_stage:
				GAME_STAGE.LEVEL1:
					change_game_stage(GAME_STAGE.CUT_TO_L2)
					target_play_time = 20
				GAME_STAGE.LEVEL2:
					change_game_stage(GAME_STAGE.CUT_TO_B1)
