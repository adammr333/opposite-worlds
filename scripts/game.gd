extends Node2D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	pass


func _process(delta: float) -> void:
	var mousePosition = get_global_mouse_position()
	pass


func _on_water_body_entered(body: Node2D) -> void:
	if body is player:
		print("Swimming")
		body.isSwimming = true
	pass


func _on_water_body_exited(body: Node2D) -> void:
	if body is player:
		print("Not Swimming")
		body.isSwimming = false
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if Input.MOUSE_MODE_CONFINED_HIDDEN:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pass
