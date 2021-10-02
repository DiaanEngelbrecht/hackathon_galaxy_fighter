extends KinematicBody2D

const MOVEMENT_RADIUS = 300
const MOVEMENT_SPEED = 150
const SAFETY_ZONE = 10

onready var player = get_tree().current_scene.find_node("Spaceship")
onready var gun = $Gun

export (PackedScene) var Bullet

var target_position
var motion = Vector2.ZERO

func _ready():
	randomize()
	position = Vector2(rand_range(SAFETY_ZONE,get_viewport().size.x/2 - SAFETY_ZONE), -50)
	target_position = Vector2(position.x, rand_range(SAFETY_ZONE,get_viewport().size.y/4 - SAFETY_ZONE))
	GameState.connect("game_over", self, "queue_free")

func _physics_process(delta):
	move_to_target(delta)
	aim_at_player()
	var collisions = move_and_collide(motion)
	if collisions:
		get_new_target_position()

func aim_at_player():
	if player:
		rotation = Vector2.DOWN.angle_to((position - player.position).normalized())

func move_to_target(delta):
	motion = position.move_toward(target_position, MOVEMENT_SPEED * delta) - position
	print("Current position",position)
	print("Target position",target_position)
	print("Motion",motion)
	if (target_position-position).length() < 10:
		shoot()
		get_new_target_position()

func shoot():
	var bullet_instance = Bullet.instance()

	bullet_instance.global_position = gun.global_position
	bullet_instance.rotation = rotation

	get_parent().add_child(bullet_instance)

	bullet_instance.set_direction(Vector2.UP.rotated(rotation - PI/60))
	
func get_new_target_position():
	var rad_offset = rand_range(0, MOVEMENT_RADIUS)
	var angle = rand_range(0, 360)
	target_position = position + Vector2(rad_offset, 0).rotated(deg2rad(angle))

	target_position.x = clamp(target_position.x,SAFETY_ZONE,get_viewport().size.x/2 - SAFETY_ZONE)
	target_position.y = clamp(target_position.y,SAFETY_ZONE,get_viewport().size.y/2 - SAFETY_ZONE)

	

func destroy():
	$AnimatedSprite.play("explosion")
	$AnimatedSprite.playing = true


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "explosion":
		GameState.increase_score(2)
		queue_free()
