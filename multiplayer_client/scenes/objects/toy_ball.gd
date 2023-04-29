extends CharacterBody2D

@export var force: Vector2
@export var is_moving := false:
	set(value):
		is_moving = value
		if value:
			set_collision_mask_value(2, false)
#			$CollisionShape2D.disabled = true
			$HamsterArea.monitoring = true
		else:
			set_collision_mask_value(2, true)
#			$CollisionShape2D.disabled = false
			$HamsterArea.monitoring = false


func _on_hamster_area_body_entered(body):
	$Squish.play()
	Game.request_kill_hamster(body.name)
