extends Path2D

export (PackedScene) var Asteroid

func _on_SpawnTimer_timeout():
	# Add an asteroid
	# Choose a random location on Path2D.
	$AsteroidSpawner.offset = randi()
	# Create a Asteroid instance and add it to the scene.
	var asteroid = Asteroid.instance()
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