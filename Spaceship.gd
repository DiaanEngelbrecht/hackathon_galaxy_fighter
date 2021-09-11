extends KinematicBody2D

# Global constants
const MOVEMENT_SPEED = 10

# Global variables
var motion

func _ready():
	motion = Vector2.ZERO

func _physics_process(delta):
	var direction = get_movement_direction()
	motion += direction * MOVEMENT_SPEED
	move_and_slide(motion)
	rotate(position.angle_to(get_global_mouse_position()))


func get_movement_direction():
	var direction = Vector2.ZERO

	if Input.is_action_pressed("move_down"):
		direction += Vector2(0,1)
	if Input.is_action_pressed("move_up"):
		direction += Vector2(0,-1)
	if Input.is_action_pressed("move_right"):
		direction += Vector2(1,0)
	if Input.is_action_pressed("move_left"):
		direction += Vector2(-1,0)

	return direction
