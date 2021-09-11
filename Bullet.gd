extends Area2D

export (int) var speed = 20

var direction := Vector2.ZERO

func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity	

func set_direction(direction: Vector2):
	self.direction = direction


func _on_VisibilityNotifier2D_screen_exited():
	print("BYE")
	queue_free()
