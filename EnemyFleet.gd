extends Node

export (PackedScene) var Enemy
export var minimum_spawn_time = 0.45

onready var game_state = GameState

func _ready():
	game_state.connect("game_stage_changed", self, "deploy_tais")

func deploy_tais(game_stage, stage_type):
	if game_state.STAGE_TYPE.PLAYABLE == stage_type:
		match game_stage:
			game_state.GAME_STAGE.LEVEL1:
				$SpawnTimer.start()
			game_state.GAME_STAGE.LEVEL2:
				$SpawnTimer.start()
	else:
		$SpawnTimer.stop()

func _on_SpawnTimer_timeout():
	var enemy = Enemy.instance()
	add_child(enemy)

	$SpawnTimer.wait_time = clamp(lerp($SpawnTimer.wait_time, minimum_spawn_time, 0.005), minimum_spawn_time, 1)
