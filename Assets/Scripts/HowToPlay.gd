extends Control

const MENU_SCENE = "res://Assets/Scenes/UI/Menu.tscn"

func _on_botao_menu_pressed():
	get_tree().change_scene_to_file(MENU_SCENE)
