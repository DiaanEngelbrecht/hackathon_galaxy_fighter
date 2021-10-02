extends Path2D

export (PackedScene) var Asteroid

onready var game_state = GameState

func _ready():
	game_state.connect("game_stage_changed", self, "enter_the_asteroid_belt")

func enter_the_asteroid_belt(game_stage, stage_type):
	if game_state.STAGE_TYPE.PLAYABLE == stage_type:
		match game_stage:
			game_state.GAME_STAGE.LEVEL2:
				$SpawnTimer.start()
	else:
		$SpawnTimer.stop()

func _on_SpawnTimer_timeout():
	# Add an asteroid
	# Choose a random location on Path2D.
	$AsteroidSpawner.offset = randi()
	# Create a Asteroid instance and add it to the scene.
	var asteroid = Asteroid.instance()
	asteroid.set_size(rand_range(1, 4))
	add_child(asteroid)
	# Set the mob's direction perpendicular to the path direction.
	var direction = $AsteroidSpawner.rotation - PI / 2
	# Set the mob's position to a random location.
	asteroid.position = $AsteroidSpawner.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	asteroid.rotation = direction
	# Set the velocity (speed & direction).
	asteroid.linear_velocity = Vector2(rand_range(asteroid.MIN_SPEED, asteroid.MAX_SPEED), 0)
	asteroid.linear_velocity = asteroid.linear_velocity.rotated(direction)

	$SpawnTimer.wait_time = clamp(lerp($SpawnTimer.wait_time, 0.25, 0.01), 0.25, 1)

	print($SpawnTimer.wait_time)
