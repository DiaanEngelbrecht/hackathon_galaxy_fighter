extends KinematicBody2D

# Global constants
const MAX_MOVEMENT_SPEED = 400
const ACCELERATION = 25
const KINETIC_FRICTION = 0.05
const IMPACT_STRENGTH = 100
const MASS = 100

# Global variables
var motion := Vector2.ZERO
var immune := false

export (PackedScene) var Bullet

onready var right_gun = $RightGun
onready var left_gun = $LeftGun


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
	fire_engines(direction)
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

func fire_engines(direction):
	if direction.length() == 0:
		$Thrustors/LeftThrustor.emitting = false
		$Thrustors/RightThrustor.emitting = false
	else:
		$Thrustors/LeftThrustor.emitting = true
		$Thrustors/RightThrustor.emitting = true

func shoot():
	var right_bullet_instance = Bullet.instance()
	var left_bullet_instance = Bullet.instance()

	right_bullet_instance.global_position = right_gun.global_position
	left_bullet_instance.global_position = left_gun.global_position
	right_bullet_instance.rotation = rotation
	left_bullet_instance.rotation = rotation

	get_parent().add_child(right_bullet_instance)
	get_parent().add_child(left_bullet_instance)

	right_bullet_instance.set_direction(Vector2.UP.rotated(rotation - PI/60))
	left_bullet_instance.set_direction(Vector2.UP.rotated(rotation + PI/60))


func _on_ForceField_body_entered(body):
	print("Something hit the spaceship")
	if body.is_in_group("asteroids") and not immune:
		take_damage(body)

func take_damage(body):
	immune = true
	$AnimationPlayer.play("Damaged")
	$ForceField/ImmunityTimer.start()
	
	var response_force_direction = body.position.direction_to(position)
	var impact_impulse = response_force_direction * IMPACT_STRENGTH * (body.linear_velocity - motion).length()
	motion += impact_impulse / MASS # Need to register a mass for our spaceship, so that the accelaration matches relative to the asteroid mass
	body.apply_impulse(Vector2.ZERO, impact_impulse.rotated(PI))


func _on_ImmunityTimer_timeout():
	immune = false
