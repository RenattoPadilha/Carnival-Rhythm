extends Node

class_name HealthComponent

signal has_died
signal health_changed (curr_health: int, max_health: int)

@export var max_health:int = 3;
var curr_health: int;

func _ready() -> void:
	curr_health = max_health;
	emit_signal("health_changed", curr_health, max_health)

func apply_damage(damage: int) -> void:
	if damage <= 0:
		return
	curr_health = max(curr_health - damage, 0)
	emit_signal("health_changed", curr_health, max_health)
	print_debug("Player Perdeu Vida")

	if curr_health == 0:
		print_debug("Player Morreu")
		emit_signal("has_died")
	
func apply_heal (heal: int) -> void:
	if heal <= 0:
		return
	curr_health = min(curr_health + heal,max_health)
	emit_signal("health_changed", curr_health, max_health)
	print_debug("Player Curou Vida")
	
