extends Control


onready var game_state = GameState

# Called when the node enters the scene tree for the first time.
func _ready():
	game_state.connect("health_changed", self, "update_health_bar")

func update_health_bar(new_player_health):
	$TextureRect.texture.region.position.x = (4 - new_player_health) * 80
