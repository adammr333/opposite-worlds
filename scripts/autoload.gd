extends Node

@onready var game: Node = get_tree().get_root().get_node("Game")
@onready var animPlayer: Node = get_tree().get_root().get_node("Game/AnimationPlayer")
@onready var titleScreen: Node = get_tree().get_root().get_node("Game/TitleScreen")

var titleState: bool
var gameState: bool
var endState: bool


func _ready() -> void:
	titleState = true
	gameState = false
	endState = false
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		if titleState:
			animPlayer.animation_finished.connect(_start_game)
			animPlayer.play("game_start")
			titleScreen.visible = false
	pass


func _start_game(anim_name: StringName):
	if anim_name == "game_start":
		titleState = false
		gameState = true
	pass
