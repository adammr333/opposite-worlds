extends Node

@onready var game: Node = get_tree().get_root().get_node("Game")
@onready var animPlayer: Node = get_tree().get_root().get_node("Game/AnimationPlayer")
@onready var titleScreen: Node = get_tree().get_root().get_node("Game/TitleScreen")
@onready var controlsLabel: Node = get_tree().get_root().get_node("Game/Player/Controls/Controls")
@onready var tutorialNode1: Node = get_tree().get_root().get_node("Game/TutorialNode1")
@onready var water: Node = get_tree().get_root().get_node("Game/Level/Water")

var titleState: bool
var gameState: bool
var endState: bool


func _ready() -> void:
	titleState = true
	gameState = false
	endState = false
	water.body_entered.connect(_on_water_entered)
	water.body_exited.connect(_on_water_exited)
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		if titleState:
			animPlayer.animation_finished.connect(_start_game)
			animPlayer.play("game_start")
			titleScreen.visible = false
			tutorialNode1.body_entered.connect(_progress_tutorial)
	pass


func _start_game(anim_name: StringName):
	if anim_name == "game_start":
		titleState = false
		gameState = true
		controlsLabel.visible = true
	pass


func _progress_tutorial(body: Node2D):
	if body is player:
		controlsLabel.text = "Hold RMB to aim.\nLMB while aiming to fire."
	pass


func _on_water_entered(body: Node2D):
	if body is player:
		controlsLabel.text = "W/A/S/D to swim\nUp/Left/Down/Right."
	pass


func _on_water_exited(body: Node2D):
	if body is player:
		controlsLabel.text = "A/D to move\nLeft/Right"
	pass
