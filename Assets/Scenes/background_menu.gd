extends ColorRect

@export var cores := [
	Color(0.55, 0.38, 0.42), # rosa queimado
	Color(0.38, 0.45, 0.60), # azul acinzentado
	Color(0.38, 0.55, 0.48), # verde musgo claro
	Color(0.50, 0.40, 0.55), # lilás fechado
	Color(0.60, 0.45, 0.35)  # pêssego escuro
]

@export var duracao := 6.0
var indice := 0

func _ready():
	_trocar_cor()

func _trocar_cor():
	var proxima_cor = cores[indice]
	indice = (indice + 1) % cores.size()

	var tween = create_tween()
	tween.tween_property(self, "color", proxima_cor, duracao)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	tween.finished.connect(_trocar_cor)
