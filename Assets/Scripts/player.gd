extends CharacterBody2D

@export var game_over_scene: String = "res://Assets/Scenes/UI/GameOver.tscn"
@export var hit_sound_player: AudioStreamPlayer

signal has_died
signal health_changed (curr_health: int, max_health: int)

@onready var health: HealthComponent = $HealthComponent
@onready var movement: MovementComponent = $MovementComponent

func _ready() -> void:
	health.has_died.connect(_on_died)
	health.health_changed.connect(_on_health_changed)
	movement.setup(self)
	
func _physics_process(delta: float) -> void:
	movement.process_movement(delta)

# --- SISTEMA DE INPUT DE RITMO ---
func _input(event):
	# Se apertar ESPAÇO (verifique se a action "Action" ou "ui_accept" está configurada)
	if event.is_action_pressed("ui_accept"): 
		verificar_acerto()

func verificar_acerto():
	var todas_notas = get_tree().get_nodes_in_group("notas")
	
	var nota_mais_proxima = null
	var menor_distancia = 1000.0
	var tempo_musica = Conductor.song_position
	
	# Pega a linha atual onde o player está (0, 1 ou 2)
	var minha_linha = movement.curr_lane_index 
	
	for nota in todas_notas:
		if nota.was_hit: continue
		
		# --- FILTRO DE LINHA ---
		# Se a nota não for da mesma linha que o player, ignora
		if nota.lane_index != minha_linha or nota.required_world_type != WorldManager.current_world_index:
			continue
		
		var distancia = abs(nota.target_time - tempo_musica)
		
		if distancia < menor_distancia:
			menor_distancia = distancia
			nota_mais_proxima = nota
	
	# Janela de acerto (0.15s)
	if nota_mais_proxima and menor_distancia < 0.15:
		# Acerto!
		if hit_sound_player:
			hit_sound_player.play()
		
		var precisao = nota_mais_proxima.target_time - tempo_musica
		ScoreManager.register_hit(precisao)
		nota_mais_proxima.destroy_on_hit()
	else:
		# Erro (apertou sem nota perto na linha)
		ScoreManager.register_miss()
		var player = self
		if player:
			var health = player.get_node_or_null("HealthComponent")
			if health:
				health.apply_damage(1)

# --- Funções de Vida/Morte ---
func take_damage(damage: int) -> void:
	health.apply_damage(damage)
	
func heal (heal: int) -> void:
	health.apply_heal(heal)
	
func _on_health_changed(curr_health: int, max_health: int):
	emit_signal("health_changed", curr_health, max_health)

func _on_died() -> void:
	Conductor.stop_music()
	get_tree().change_scene_to_file(game_over_scene)
	queue_free()
