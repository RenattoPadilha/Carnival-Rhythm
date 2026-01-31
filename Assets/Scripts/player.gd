extends CharacterBody2D

signal has_died
signal health_changed (curr_health: int, max_health: int)

@onready var health: HealthComponent = $HealthComponent
@onready var movement: MovementComponent = $MovementComponent

func _ready() -> void:
	health.has_died.connect(_on_died)
	health.health_changed.connect(_on_health_changed)
	movement.setup(self)
	
func _physics_process(delta: float) -> void:
	movement.process_movement(delta)

func take_damage(damage: int) -> void:
	health.apply_damage(damage)
	
func heal (heal: int) -> void:
	health.apply_heal(heal)
	
func _on_health_changed(curr_health: int, max_health: int):
	emit_signal("health_changed", curr_health, max_health)

func _on_died() -> void:
	emit_signal("has_died")
	queue_free()
