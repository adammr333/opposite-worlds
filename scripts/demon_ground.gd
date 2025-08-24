extends Area2D
class_name demon_ground

const SPEED = 250

@onready var attackController = get_tree().get_root().get_node("Game/Player/AttackController")

var canBeShot: bool = false

signal _demon_shot


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	attackController.shoot_gun.connect(_on_shoot_gun)


func _physics_process(delta: float) -> void:
	position -= Vector2(1, 0) * SPEED * delta
	pass


func _on_area_entered(area: Area2D):
	canBeShot = true
	pass


func _on_area_exited(area: Area2D):
	canBeShot = false
	pass


func _on_shoot_gun():
	if canBeShot:
		emit_signal("_demon_shot")
		queue_free()
	pass
