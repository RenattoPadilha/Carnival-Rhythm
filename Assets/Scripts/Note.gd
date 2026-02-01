extends Node2D

@export var lane_visuals: Array[Texture2D] 
const LANE_POSITIONS = [143, 17, -143]

# Spawner Config
var target_time: float = 0.0
var spawn_time: float = 0.0
var start_x: float = 0.0
var end_x: float = 0.0
var speed: float = 0.0
var was_hit: bool = false

# --- NOVO: Variável para guardar a linha ---
var lane_index: int = 0 
# ----------------------------------------

func setup(t_time: float, t_spawn: float, p_start: Vector2, p_end: Vector2, p_speed: float, p_lane_index: int):
	target_time = t_time
	spawn_time = t_spawn
	start_x = p_start.x
	end_x = p_end.x
	speed = p_speed
	lane_index = p_lane_index # Recebe a linha na criação
	
	global_position = p_start

func _ready():
	add_to_group("notas") # Importante para o Player encontrar a nota

func _process(_delta):
	if was_hit:
		return

	# Movimento baseado no tempo da música
	var time = Conductor.song_position
	var time_diff = target_time - time
	
	# Calcula posição atual
	# Nota: Verifique se no seu jogo as notas vão da direita pra esquerda (-) ou o contrário (+)
	# No seu código original estava "end_x - ...", aqui mantive a lógica de aproximação
	var new_x = end_x + (time_diff * speed) 
	position.x = new_x
	
	# Se passar muito do tempo (0.2s), conta como erro
	if time > target_time + 0.2:
		_on_miss()

func destroy_on_hit():
	was_hit = true
	queue_free()

func _on_miss():
	if not was_hit:
		ScoreManager.register_miss()
		queue_free()


func setup_visuals(current_lane_index: int):
	for i in range(3):
		if i != current_lane_index:
			var sprite = Sprite2D.new()
			sprite.texture = lane_visuals[i]
			
			add_child(sprite)
			
			sprite.global_position = Vector2(global_position.x, LANE_POSITIONS[i])
			sprite.scale = Vector2(0.5, 0.5)
			
			# sprite.modulate = Color(0.5, 0.5, 0.5, 1) # Opcional: Escurecer
