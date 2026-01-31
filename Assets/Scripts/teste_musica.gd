extends Node2D

@export var level_music: AudioStream 
@export var bpm: int = 130
@export var measures: int = 4
@onready var spawner = $"../Spawner"

func _ready():
	Conductor.load_song(level_music, bpm, measures)
	spawner.generate_map()
	Conductor.play_from_start()
