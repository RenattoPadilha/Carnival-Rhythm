extends CharacterBody2D

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

func take_damage(damage: int) -> void:
	health.apply_damage(damage)
	
func heal (heal: int) -> void:
	health.apply_heal(heal)
	
func _on_health_changed(curr_health: int, max_health: int):
	emit_signal("health_changed", curr_health, max_health)

func _on_died() -> void:
	emit_signal("has_died")
	queue_free()
	
func _input(event):
	# Se apertar ESPAÇO (ou a tecla que você configurou)
	if event.is_action_pressed("ui_accept"): 
		verificar_acerto()

func verificar_acerto():
	# 1. Pega todas as notas que existem na tela agora
	var todas_notas = get_tree().get_nodes_in_group("notas")
	
	var nota_mais_proxima = null
	var menor_distancia = 1000.0 # Começa com um número gigante
	
	var tempo_musica = Conductor.song_position # Pega o tempo do seu Conductor
	
	# 2. Loop para encontrar a "escolhida"
	for nota in todas_notas:
		if nota.was_hit: continue # Pula se já foi acertada
		
		# Calcula a distância em tempo (abs tira o sinal negativo)
		var distancia = abs(nota.target_time - tempo_musica)
		
		if distancia < menor_distancia:
			menor_distancia = distancia
			nota_mais_proxima = nota
	
	# 3. Verifica se a nota mais próxima está perto o suficiente para contar (ex: 0.15 segundos)
	if nota_mais_proxima and menor_distancia < 0.15:
		nota_mais_proxima.destroy_on_hit()
		
		# Calcula pontuação baseada na precisão
		var pontos = 100
		if menor_distancia < 0.05: pontos = 300 # Perfeito
		
		ScoreManager.adicionar_pontos(pontos)
		print("Acertou! Distância: ", menor_distancia)
		
	else:
		print("Errou (Miss) ou apertou o botão no vento")
		ScoreManager.resetar_combo()
