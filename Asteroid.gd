extends RigidBody2D

const MAX_SPEED = 300
const MIN_SPEED = 200

var custom_scale := Vector2.ZERO

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func destroy_asteroid():
	$AnimatedSprite.play("explosion")
	$AnimatedSprite.playing = true

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "explosion":
		queue_free()

func set_size(new_size):
	var default_mass = pow(500.0, 1.0/3.0)
	mass = pow((new_size * default_mass), 3.0)
	custom_scale = Vector2(new_size, new_size)
	$AnimatedSprite.scale = custom_scale
	$CollisionShape2D.scale = custom_scale
