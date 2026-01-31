extends Node2D

#Spawner Config
var target_time: float = 0.0 # O segundo exato que ela deve ser tocada
var spawn_time: float = 0.0  # Quando ela foi criada
var dist_to_target: float = 0.0 # Distância em pixels até a linha de acerto
var start_x: float = 0.0     # Onde ela nasceu (Y)
var end_x: float = 0.0       # Onde é a linha de acerto (Y)
var speed: float = 0.0       # Pixels por segundo
var was_hit: bool = false

func setup(t_time: float, t_spawn: float, p_start: Vector2, p_end: Vector2, p_speed: float):
	
	target_time = t_time
	spawn_time = t_spawn
	start_x = p_start.x
	end_x = p_end.x
	speed = p_speed
	
	global_position = p_start

func _process(_delta):
	if was_hit:
		return

	#Calc new X position
	var time = Conductor.song_position
	var time_diff = target_time - time
	var new_x = end_x - (time_diff * speed)
	position.x = new_x
	
	if time > target_time + 0.2:
		_on_miss()
	$Label.text = str(snapped(target_time - Conductor.song_position, 0.01))

func destroy_on_hit():
	was_hit = true
	queue_free()

func _on_miss():
	queue_free()
