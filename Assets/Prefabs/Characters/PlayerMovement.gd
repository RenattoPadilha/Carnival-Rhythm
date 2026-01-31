extends Node

class_name MovementComponent

@export var speed: float = 200
@export var lines: Array[float] = [192, 0, -192]
@export var line_change_speed: float = 10

var body: CharacterBody2D
var curr_lane_index: int

func _ready() -> void:
	pass # Replace with function body.

func setup(character: CharacterBody2D):
	body = character
	curr_lane_index = 0
	body.position.y = lines[curr_lane_index]

func process_movement(delta: float) -> void:
	_handle_mov_input()
	_apply_movement(delta)

func _handle_mov_input():
	if Input.is_action_just_released("move_up"):
		curr_lane_index = min(curr_lane_index+1, lines.size()-1)
	if Input.is_action_just_released("move_down"):
		curr_lane_index = max(curr_lane_index-1, 0)

func _apply_movement(delta: float):
	body.velocity.x = speed
	
	#changing line
	var target_y = lines[curr_lane_index]
	body.position.y = lerp(body.position.y, target_y, line_change_speed * delta)
	
	body.move_and_slide()
