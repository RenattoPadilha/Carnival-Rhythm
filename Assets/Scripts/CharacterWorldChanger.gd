extends AnimatedSprite2D

@export var skins: Array[SpriteFrames]

func _ready():
	WorldManager.world_changed.connect(_on_world_changed)
	_on_world_changed(WorldManager.current_world_index)

func _on_world_changed(index: int):
	# Segurança básica
	if index >= skins.size() or skins[index] == null:
		return

	var curr_anim = animation
	var curr_frame = frame
	var was_playing = is_playing()
	
	sprite_frames = skins[index]
	
	if was_playing:
		play(curr_anim)
		frame = curr_frame
	else:
		animation = curr_anim
		frame = curr_frame
