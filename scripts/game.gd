extends Node2D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN


func _process(delta: float) -> void:
	var mousePosition = get_global_mouse_position()


func _on_water_body_entered(body: Node2D) -> void:
	if body is player:
		print("Swimming")
		body.isSwimming = true


func _on_water_body_exited(body: Node2D) -> void:
	if body is player:
		print("Not Swimming")
		body.isSwimming = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if Input.MOUSE_MODE_CONFINED_HIDDEN:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
