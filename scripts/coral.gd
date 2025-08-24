extends Area2D

@onready var collectionLabel: Node = get_tree().get_root().get_node("Game/CollectionTooltip")

var canBeGathered: bool = false

signal _coral_gathered


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D):
	if body is player:
		canBeGathered = true


func _on_body_exited(body: Node2D):
	if body is player:
		canBeGathered = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("space") && canBeGathered:
		gatherCoral()


func gatherCoral():
	emit_signal("_coral_gathered")
	visible = false
	canBeGathered = false
	monitoring = false
	$RespawnTimer.start()
	$RespawnTimer.timeout.connect(respawn_coral)
	if collectionLabel.visible == true:
		collectionLabel.visible = false


func respawn_coral():
	visible = true
	monitoring = true
