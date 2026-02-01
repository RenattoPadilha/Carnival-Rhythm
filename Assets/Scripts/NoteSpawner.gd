extends Node2D

@export var note_scene: PackedScene = load("res://Assets/Prefabs/Notes/Note-1.tscn")
@export var travel_time: float = 4.0
@export var notes_per_beat: int = 1

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
	new_note.setup_visuals(lane_id)

func generate_map():
	map_data.clear()
	current_note_index = 0
	
	var total_measures = Conductor.get_total_measures_in_song()
	var sec_per_beat = Conductor.sec_per_beat
	var beats_per_measure = Conductor.measures # Geralmente é 4
	
	if total_measures <= 0 or sec_per_beat <= 0:
		return

	var interval = sec_per_beat * beats_per_measure
	
	var total_steps = total_measures 
	
	var current_time = 0.0
	var last_lane = -1
	
	for i in range(total_steps):
		
		if i < 1: # Pula apenas o index 0 (primeiro compasso)
			current_time += interval
			continue
		
		var new_lane = randi() % 3
		
		if new_lane == last_lane and randf() > 0.5:
			new_lane = (new_lane + 1) % 3
		last_lane = new_lane
		
		map_data.append({
			"time": current_time,
			"lane": new_lane
		})
		
		current_time += interval
