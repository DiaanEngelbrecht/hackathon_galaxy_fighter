extends Node

var weapons = []
onready var current_weapon = $Weapons/DoubleLaserCanon

func _ready():
	randomize()
	weapons = $Weapons.get_children()

func get_random_weapon_index():
	return randi()%len(weapons)

func get_weapon_for_index(index):
	return weapons[index]

func set_current_weapon_by_index(index):
	current_weapon = weapons[index]

func fire_current_weapon(spaceship):
	current_weapon.shoot(spaceship)
