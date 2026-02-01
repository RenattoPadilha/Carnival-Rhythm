extends Label

func _ready():
	await get_tree().process_frame
	
	var player = get_tree().current_scene.find_child("Player", true, false)
	
	if player:
		var health_comp = player.get_node("HealthComponent")
		
		health_comp.health_changed.connect(_update_text)
		
		_update_text(health_comp.curr_health, health_comp.max_health)
	else:
		text = "Erro: Player não achado"

func _update_text(current, max_hp):
	text = "VIDA: " + str(current) + " / " + str(max_hp)
