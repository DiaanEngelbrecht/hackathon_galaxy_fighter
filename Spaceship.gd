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
var viewport_x := 480
var viewport_y := 720

onready var game_state = GameState
onready var armory = Armory

func _ready():
	viewport_x = ProjectSettings.get_setting("display/window/size/width")
	viewport_y = ProjectSettings.get_setting("display/window/size/height")
	print("Viewport x dimension: ", viewport_x)
	motion = Vector2.ZERO
	game_state.connect("game_over", self, "queue_free")

func _physics_process(_delta):
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
	ensure_confined_to_viewport()
	
func ensure_confined_to_viewport():
	position.x = clamp(position.x, 0, viewport_x)
	position.y = clamp(position.y, 0, viewport_y)

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

func _input(event):
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
	armory.fire_current_weapon(self)

func _on_ForceField_body_entered(body):
	if body.is_in_group("asteroids"):
		take_damage()
		recoil(body)

func take_damage():
	if not immune:
		game_state.decrement_health()
		immune = true
		$AnimationPlayer.play("Damaged")
		$ForceField/ImmunityTimer.start()

func recoil(body):
	var response_force_direction = body.position.direction_to(position)
	var impact_impulse = response_force_direction * IMPACT_STRENGTH * (body.linear_velocity - motion).length()
	motion += impact_impulse / MASS # Need to register a mass for our spaceship, so that the accelaration matches relative to the asteroid mass
	body.apply_impulse(Vector2.ZERO, impact_impulse.rotated(PI))


func _on_ImmunityTimer_timeout():
	immune = false
