extends Label

func _ready():
	# Conecta no sinal do Global
	# "Sempre que o score mudar, avise essa função"
	ScoreManager.score_updated.connect(atualizar_texto)
	text = "Score: 0" # Texto inicial

func atualizar_texto(novo_score):
	text = "Score: " + str(novo_score)
