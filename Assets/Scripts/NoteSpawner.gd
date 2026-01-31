extends Node2D

@export var note_scene: PackedScene = load("res://Assets/Prefabs/Notes/Note-1.tscn")
@export var travel_time: float = 4.0

var map_data: Array = [] 
var current_note_index: int = 0

var spawn_positions: Array[Vector2] = []
var end_positions: Array[Vector2] = []
func _ready() -> void:
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
	
	new_note.setup(
		note_data["time"],    # Target Time
		Conductor.song_position, # Spawn Time
		start_pos,
		end_pos,
		speed
	)

# Função temporária para criarmos dados sem precisar de arquivos externos ainda
func _load_test_map():
	map_data = [
		{"time": 8.0, "lane": 0}, # Nota na linha 1 aos 2s
		{"time": 10.0, "lane": 1}, # Nota na linha 2 aos 3s
		{"time": 12.0, "lane": 2}, # Nota na linha 3 aos 4s
		{"time": 14.0, "lane": 1}, # Nota rápida
		{"time": 16.0, "lane": 0},
		{"time": 20.0, "lane": 2}

	]
