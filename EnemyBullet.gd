extends Area2D

export (int) var speed = 10

var direction := Vector2.ZERO

func _physics_process(_delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity

func set_direction(new_direction: Vector2):
	self.direction = new_direction

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_EnemyBullet_body_entered(body):
	if body.is_in_group("destructable"):
		body.destroy()
	if body.is_in_group("player"):
		body.take_damage()
	queue_free()
	
