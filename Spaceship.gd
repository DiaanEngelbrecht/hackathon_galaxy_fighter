extends KinematicBody2D

# Global constants
const MAX_MOVEMENT_SPEED = 400
const ACCELERATION = 25
const KINETIC_FRICTION = 0.05

# Global variables
var motion

export (PackedScene) var Bullet

onready var end_of_gun = $EndOfGun
onready var gun2 = $gun2


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

func _unhandled_input(event):
	if event.is_action_released('shoot'):
		shoot()
		
		
func shoot():
	var bullet_instance1 = Bullet.instance()
	var bullet_instance2 = Bullet.instance()
	add_child(bullet_instance1)
	add_child(bullet_instance2)
	bullet_instance1.global_position = end_of_gun.global_position
	bullet_instance2.global_position = gun2.global_position
	var target = get_global_mouse_position()
	var direction_to_mouse1 = bullet_instance1.global_position.direction_to(target).normalized()
	bullet_instance1.set_direction(direction_to_mouse1)
	var direction_to_mouse2 = bullet_instance2.global_position.direction_to(target).normalized()
	bullet_instance2.set_direction(direction_to_mouse2)
	print('shot!')
