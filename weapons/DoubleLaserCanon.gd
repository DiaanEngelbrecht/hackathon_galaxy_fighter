extends Node


export (PackedScene) var bullet

func shoot(spaceship):
	var right_bullet_instance = bullet.instance()
	var left_bullet_instance = bullet.instance()

	right_bullet_instance.global_position = spaceship.get_node("RightGun").global_position
	left_bullet_instance.global_position = spaceship.get_node("LeftGun").global_position
	right_bullet_instance.rotation = spaceship.rotation
	left_bullet_instance.rotation = spaceship.rotation

	spaceship.get_parent().add_child(right_bullet_instance)
	spaceship.get_parent().add_child(left_bullet_instance)

	right_bullet_instance.set_direction(Vector2.UP.rotated(spaceship.rotation - PI/60))
	left_bullet_instance.set_direction(Vector2.UP.rotated(spaceship.rotation + PI/60))
