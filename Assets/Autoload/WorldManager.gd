extends Node

signal world_changed(new_world_index)

# 0 = Ursa, 1 = Wayana, 2 = Guara
var current_world_index: int = 0
var is_game_active: bool = true # Mude isso ao entrar/sair do menu

func _input(event):
	if not is_game_active: return

	if event.is_action_pressed("change_world"):
		current_world_index = (current_world_index + 1) % 3
		world_changed.emit(current_world_index)
