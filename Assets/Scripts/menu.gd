extends Control

const GAME_SCENE = "res://Assets/Scenes/RhythmGame.tscn"
const HOWTO_SCENE = "res://Assets/Scenes/UI/HowToPlay.tscn"
const CREDITS_SCENE = "res://Assets/Scenes/UI/Credits.tscn"

func _on_botao_jogar_pressed():
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_botao_howto_pressed():
	get_tree().change_scene_to_file(HOWTO_SCENE)

func _on_botao_credits_pressed():
	get_tree().change_scene_to_file(CREDITS_SCENE)
