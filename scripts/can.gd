extends Area2D

@onready var attackController = get_tree().get_root().get_node("Game/Player/AttackController")
@onready var animPlayer = $AnimationPlayer

var canBeShot: bool = false


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	attackController.shoot_gun.connect(_on_shoot_gun)


func _on_area_entered(area: Area2D):
	canBeShot = true
	print(canBeShot)


func _on_area_exited(area: Area2D):
	canBeShot = false
	print(canBeShot)
	pass


func _on_shoot_gun():
	if canBeShot:
		animPlayer.play("can_shot")
		animPlayer.animation_finished.connect(_on_animation_finished)
	pass


func _on_animation_finished(anim_name: StringName):
	if anim_name == "can_shot":
		queue_free()
	pass
