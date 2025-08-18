extends Node

const SPEED = 400.0

@onready var player: Node = $".."
@onready var playerSprite: Node = $"../Sprite2D"
@onready var animPlayer: Node = $"../AnimationPlayer"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	if Autoload.gameState:
		if not player.is_on_floor() && !player.isSwimming:
			player.velocity.y += gravity * delta
		var moveDir: Vector2 = Input.get_vector("left", "right", "up", "down")
		if moveDir:
			player.velocity.x = (moveDir.x * SPEED)
			animPlayer.play("run")
			if moveDir.x < 0:
				playerSprite.scale.x = -1
			else:
				playerSprite.scale.x = 1
			if player.isSwimming:
				player.velocity.y = moveDir.y * SPEED
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
			if player.isSwimming:
				player.velocity.y = move_toward(player.velocity.y, 0, SPEED)
			animPlayer.stop()
		player.move_and_slide()
