extends CharacterBody2D

@onready var health: HealthComponent = $HealthComponent

func _ready() -> void:
	health.has_died.connect(_on_died)
	
func take_damage(damage: int) -> void:
	health.apply_damage(damage)
	
func heal (heal: int) -> void:
	health.apply_heal(heal)
	
func _on_died() -> void:
	queue_free()
