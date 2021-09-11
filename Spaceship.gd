extends KinematicBody2D

# Global constants
const MAX_MOVEMENT_SPEED = 400
const ACCELERATION = 25
const KINETIC_FRICTION = 0.05

# Global variables
var motion

func _ready():
	motion = Vector2.ZERO

func _physics_process(delta):
	move_spaceship()
	rotate_spaceship()

func move_spaceship():
	var direction = get_movement_direction()

	motion += direction * ACCELERATION

	var motion_direction = motion.normalized()
	var motion_magnitude = clamp(motion.length() * (1-KINETIC_FRICTION), 0, MAX_MOVEMENT_SPEED)
	motion = motion_magnitude * motion_direction
	move_and_slide(motion)

func rotate_spaceship():
	rotation = Vector2.DOWN.angle_to((position - get_global_mouse_position()).normalized())

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

