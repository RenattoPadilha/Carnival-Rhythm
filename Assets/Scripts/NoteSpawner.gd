extends Node2D

@export var note_scene: PackedScene = load("res://Assets/Prefabs/Notes/Note-1.tscn")
@export var travel_time: float = 4.0

var map_data: Array = [] 
var current_note_index: int = 0

var spawn_positions: Array[Vector2] = []
var end_positions: Array[Vector2] = []

func _ready() -> void:
	# Pega as posições dos marcadores que você copiou
	spawn_positions = [
		$Spawn_Line_0.global_position,
		$Spawn_Line_1.global_position,
		$Spawn_Line_2.global_position
	]
	end_positions = [
		$End_Line_0.global_position,
		$End_Line_1.global_position,
		$End_Line_2.global_position
	]
	_load_test_map()
	
func _process(_delta):
	if current_note_index >= map_data.size():
		return
		
	var next_note = map_data[current_note_index]
	var target_time = next_note["time"]
	
	if Conductor.song_position >= target_time - travel_time:
		_spawn_note(next_note)
		current_note_index += 1
		# Chama recursivamente caso tenha notas muito próximas (acordes)
		_process(_delta)

func _spawn_note(note_data):
	var lane_id = note_data["lane"] # 0, 1 ou 2
	
	if lane_id < 0 or lane_id >= spawn_positions.size():
		return
		
	var new_note = note_scene.instantiate()
	add_child(new_note)
	
	var start_pos = spawn_positions[lane_id]
	var end_pos = end_positions[lane_id]
	
	var distance = start_pos.distance_to(end_pos)
	var speed = distance / travel_time
	
	# --- ATUALIZADO: Passa o lane_id no final ---
	new_note.setup(
		note_data["time"],
		Conductor.song_position,
		start_pos,
		end_pos,
		speed,
		lane_id 
	)

func _load_test_map():
	# Mapa de teste simples
	map_data = [
		{"time": 4.0, "lane": 0},
		{"time": 6.0, "lane": 1},
		{"time": 8.0, "lane": 2},
		{"time": 9.0, "lane": 1},
		{"time": 10.0, "lane": 0}
	]
