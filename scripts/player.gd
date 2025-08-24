extends CharacterBody2D
class_name player

@onready var playerSprite: Node = $Sprite2D
@onready var animPlayer: Node = $AnimationPlayer
@onready var gun: Node = $Gun

var isSwimming: bool


func _ready() -> void:
	Autoload._game_start.connect(game_start)
	Autoload._tutorial_end.connect(tutorial_end)
	Autoload.grab_gun.connect(grab_gun)
	playerSprite.rotation_degrees -= 90
	pass


func _process(delta: float) -> void:
	if isSwimming:
		playerSprite.modulate = Color(0.0, 0.75, 1.0, 1.0)
	else:
		playerSprite.modulate = Color(1.0, 1.0, 1.0, 1.0)


func game_start():
	animPlayer.play("game_start")


func grab_gun():
	gun.visible = true


func tutorial_end():
	animPlayer.play("tutorial_end")
