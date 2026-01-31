extends Button
@export var panel: Panel
@onready var anim := panel.get_node("AnimationPlayer")
@export var cor_texto := Color.WHITE
func _ready():
	var bg = get_tree().get_first_node_in_group("background")
	if bg:
		bg.cor_atualizada.connect(_atualizar_cor)

func _atualizar_cor(cor_bg: Color):
	var luminancia = (
		0.2126 * cor_bg.r +
		0.7152 * cor_bg.g +
		0.0722 * cor_bg.b
	)

	# fundo claro → texto escuro
	var nova_cor := Color(0.05, 0.05, 0.05)
	if luminancia < 0.6:
		nova_cor = Color(1, 1, 1)

	# ⚠️ DEFINIR TODOS OS ESTADOS
	add_theme_color_override("font_color", nova_cor)
	add_theme_color_override("font_hover_color", nova_cor)
	add_theme_color_override("font_pressed_color", nova_cor)
	add_theme_color_override("font_focus_color", nova_cor)
	add_theme_color_override("font_disabled_color", nova_cor)

func _on_pressed() -> void:
	panel.visible = !panel.visible # Replace with function body.
