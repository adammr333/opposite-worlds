extends CharacterBody2D
class_name player

@onready var playerSprite: Node = $Sprite2D

var isSwimming: bool


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if isSwimming:
		playerSprite.modulate = Color(0.0, 0.75, 1.0, 1.0)
	else:
		playerSprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
