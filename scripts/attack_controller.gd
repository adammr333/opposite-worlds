extends Node

@onready var player: Node = $".."
@onready var aimCursor: Node = $"../AimCursor"

var isAiming: bool

signal shoot_gun


func _process(delta: float) -> void:
	aimCursor.global_position = aimCursor.get_global_mouse_position()
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("r_click") && Autoload.gameState:
		aimCursor.visible = true
		isAiming = true
		Input.warp_mouse(Vector2(1280/2 + 50, 720/2))
	if event.is_action_released("r_click"):
		aimCursor.visible = false
		isAiming = false
	if event.is_action_pressed("l_click") && isAiming && Autoload.coralCount > 0:
		print("FIRE!")
		emit_signal("shoot_gun")
	pass
