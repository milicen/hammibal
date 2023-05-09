extends CharacterBody2D

@export var force: Vector2
@export var is_moving := false:
	set(value):
		is_moving = value
		if value:
#			set_collision_mask_value(2, false)
			set_collision_layer_value(3, false)
#			$CollisionShape2D.disabled = true
			$HamsterArea.monitoring = true
		else:
#			set_collision_mask_value(2, true)
			set_collision_layer_value(3, true)
#			$CollisionShape2D.disabled = false
			$HamsterArea.monitoring = false


func _on_hamster_area_body_entered(body):
	if body.scale.x <= 0.5:
		$Squish.play()
		Game.request_kill_hamster(body.name)
	else:
		print('move ball')
		Game.rpc('move_toy_ball', self.name, force.bounce(body.global_position.direction_to(global_position)))
#		Game.move_toy_ball(self.name, force.bounce(body.global_position.direction_to(global_position)))
