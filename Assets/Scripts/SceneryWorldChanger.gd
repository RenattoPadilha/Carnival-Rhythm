extends Node2D
@export var world_maps: Array[TileMapLayer]

func _ready():
	WorldManager.world_changed.connect(_update_map)
	_update_map(WorldManager.current_world_index)

func _update_map(active_index: int):
	for i in range(world_maps.size()):
		var map = world_maps[i]
		var is_active = (i == active_index)
		map.visible = is_active
