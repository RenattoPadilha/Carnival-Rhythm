extends Node

# Sinais avisam para o resto do jogo que algo mudou (ex: atualizar a UI)
signal score_updated(new_score: int)
signal combo_updated(new_combo: int)

# Variáveis de estado
var current_score: int = 0
var current_combo: int = 0
var multiplier: int = 1

# Configurações de pontuação
const SCORE_PERFECT = 100
const SCORE_GOOD = 50
const SCORE_OK = 10

func _ready():
	reset_score()

func reset_score():
	current_score = 0
	current_combo = 0
	multiplier = 1
	_update_signals()

# Função chamada quando o jogador acerta uma nota
func register_hit(accuracy_time: float):
	# Calcula pontos baseados na precisão (diferença de tempo)
	var points = 0
	var abs_diff = abs(accuracy_time)
	
	if abs_diff <= 0.05: # 50ms (Muito preciso)
		points = SCORE_PERFECT
		print("PERFECT!")
	elif abs_diff <= 0.1: # 100ms
		points = SCORE_GOOD
		print("GOOD")
	else:
		points = SCORE_OK
		print("OK")
	
	# Aplica combo e multiplicador
	current_combo += 1
	current_score += points * multiplier
	
	# (Opcional) Aumenta multiplicador a cada 10 hits
	multiplier = 1 + (current_combo / 10)
	
	_update_signals()

# Função chamada quando o jogador erra
func register_miss():
	current_combo = 0
	multiplier = 1
	print("MISS")
	_update_signals()

func _update_signals():
	score_updated.emit(current_score)
	combo_updated.emit(current_combo)
