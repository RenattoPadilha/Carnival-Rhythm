extends Sprite2D
@export var world_sprites: Array[Texture2D] 

func _ready():
	WorldManager.world_changed.connect(_update_skin)
	
	_update_skin(WorldManager.current_world_index)

func _update_skin(index: int):
	if index < world_sprites.size() and world_sprites[index] != null:
		
		texture = world_sprites[index]
