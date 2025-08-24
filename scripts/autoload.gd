extends Node

@onready var game: Node = get_tree().get_root().get_node("Game")
@onready var animPlayer: Node = get_tree().get_root().get_node("Game/AnimationPlayer")
@onready var titleScreen: Node = get_tree().get_root().get_node("Game/TitleScreen")
@onready var controlsLabel: Node = get_tree().get_root().get_node("Game/Player/Controls/Controls")
@onready var tutorialNode1: Node = get_tree().get_root().get_node("Game/TutorialNode1")
@onready var water: Node = get_tree().get_root().get_node("Game/Level/Water")
@onready var can: Node = get_tree().get_root().get_node("Game/Can")
@onready var canTooltip: Node = get_tree().get_root().get_node("Game/CanTooltip")
@onready var coralParent: Node = get_tree().get_root().get_node("Game/CoralParent")
@onready var kelpParent: Node = get_tree().get_root().get_node("Game/KelpParent")
@onready var gameUI: Node = get_tree().get_root().get_node("Game/Player/PlayerCamera/GameUI")
@onready var coralCountLabel: Node = gameUI.get_node("CoralCount")
@onready var kelpCountLabel: Node = gameUI.get_node("KelpCount")
@onready var player: Node = get_tree().get_root().get_node("Game/Player")
@onready var playerAttackController: Node = get_tree().get_root().get_node("Game/Player/AttackController")
@onready var gameStartTimer: Node = game.get_node("GameStartTimer")
@onready var demonParent: Node = game.get_node("DemonParent")
@onready var demonSpawnTimer: Node = game.get_node("DemonSpawnTimer")
@onready var cabinBoundary: Node = game.get_node("Level/CabinBoundaryDemon")
@onready var collectionLabel: Node = game.get_node("CollectionTooltip")
@onready var gun: Node = game.get_node("Gun")
@onready var gunLabel: Node = game.get_node("GunTooltip")

var titleState: bool
var tutorialState: bool
var gameState: bool
var endState: bool
var canTooltipToggle: bool = true
var coralCount: int = 1
var kelpCount: int = 0
var demonGroundLoad = load("res://scenes/demon_ground.tscn")
var demonFlyLoad = load("res://scenes/demon_fly.tscn")
var cabinDamage: int = 0
var demonDeathCount: int = 0
var gunExists: bool = true

var coralArray: Array = []
var kelpArray: Array = []
var demonArray: Array = []

signal _game_start
signal grab_gun
signal _tutorial_end


func _ready() -> void:
	titleState = true
	tutorialState = true
	gameState = false
	endState = false
	water.body_entered.connect(_on_water_entered)
	water.body_exited.connect(_on_water_exited)
	can._can_is_shot.connect(_can_is_shot)
	playerAttackController.shoot_gun.connect(_shoot_gun)
	coralCountLabel.text = "Coral: " + str(coralCount)
	kelpCountLabel.text = "Kelp: " +str(kelpCount)
	coralArray = coralParent.get_children()
	kelpArray = kelpParent.get_children()
	for each in coralArray:
		each._coral_gathered.connect(_coral_gathered)
	#for each in kelpArray:
		#each._kelp_gathered.connect(_kelp_gathered)
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		if titleState:
			emit_signal("_game_start")
			gameStartTimer.start()
			gameStartTimer.timeout.connect(_on_gamestart_timeout)
			titleScreen.visible = false
			tutorialNode1.body_entered.connect(_progress_tutorial)
	pass


func _on_gamestart_timeout():
	_start_game()


func _start_game():
	titleState = false
	gameState = true
	controlsLabel.visible = true
	gunLabel.visible = true
	pass


func _progress_tutorial(body: Node2D):
	if body is player:
		if canTooltipToggle:
			controlsLabel.text = "Hold RMB to aim.\nLMB while aiming to fire."
			canTooltip.visible = true
			collectionLabel.visible = true
			gunLabel.visible = false
			if gunExists:
				gun.queue_free()
				emit_signal("grab_gun")
				gunExists = false
		elif coralCount >= 2:
			end_tutorial()
	pass


func _on_water_entered(body: Node2D):
	if body is player:
		controlsLabel.text = "W/A/S/D to swim\nUp/Left/Down/Right."
	pass


func _on_water_exited(body: Node2D):
	if body is player:
		controlsLabel.text = "A/D to move\nLeft/Right."
	pass


func _can_is_shot():
	canTooltip.visible = false
	canTooltipToggle = false
	pass


func _coral_gathered():
	coralCount += 2
	coralCountLabel.text = "Coral: " + str(coralCount)
	pass


func _kelp_gathered():
	kelpCount += 1
	kelpCountLabel.text = "Kelp: " + str(kelpCount)
	pass


func _shoot_gun():
	coralCount -= 1
	coralCountLabel.text = "Coral: " + str(coralCount)
	pass


func end_tutorial():
	gameState = false
	controlsLabel.visible = false
	gameUI.visible = false
	emit_signal("_tutorial_end")
	animPlayer.play("tutorial_end")
	animPlayer.animation_finished.connect(_on_animation_finished)
	var demonGround: Node = demonGroundLoad.instantiate()
	demonParent.add_child(demonGround)
	var demonFly: Node = demonFlyLoad.instantiate()
	demonParent.add_child(demonFly)
	demonArray = demonParent.get_children()
	for each in demonArray:
		each._demon_shot.connect(on_demon_shot)
	pass


func _on_animation_finished(anim_name: StringName):
	if anim_name == "tutorial_end":
		gameState = true
		tutorialState = false
		tutorialNode1.queue_free()
		gameUI.visible = true
		demonSpawnTimer.start()
		demonSpawnTimer.timeout.connect(_on_demonspawn_timeout)
		cabinBoundary.area_entered.connect(_on_demon_entered)
	pass


func _on_demonspawn_timeout():
	var demonGround: Node = demonGroundLoad.instantiate()
	demonParent.add_child(demonGround)
	var demonFly: Node = demonFlyLoad.instantiate()
	demonParent.add_child(demonFly)
	demonArray = demonParent.get_children()
	for each in demonArray:
		each._demon_shot.connect(on_demon_shot)
	pass


func _on_demon_entered(area: Node2D):
	if area is demon_ground || area is demon_fly:
		area.queue_free()
		cabinDamage += 1
		print(cabinDamage)
		if cabinDamage == 10:
			get_tree().quit()
	pass


func on_demon_shot():
	demonDeathCount += 1
	print("Demons" + str(demonDeathCount))
	if demonDeathCount == 10:
		get_tree().quit()
	pass
