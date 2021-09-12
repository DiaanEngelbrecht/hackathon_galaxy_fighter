extends Node

var player_health
var score
var high_score

signal game_over
signal score_increaded(new_score)
signal health_changed(new_health)

func _ready():
	player_health = 4
	score = 0

func increase_score(amount_to_increase):
	score += amount_to_increase
	emit_signal('score_increaded', score)

func decrement_health():
	player_health -= 1
	if player_health == 0:
		# Emit player death signal here
		emit_signal("game_over")
	else:
		emit_signal("health_changed", player_health)
