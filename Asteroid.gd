extends RigidBody2D

const MAX_SPEED = 300
const MIN_SPEED = 200

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
