extends StaticBody2D


@export var force: Vector2
@export var is_moving := false:
	set(value):
		is_moving = value
		if value:
			$HamsterArea.monitoring = true
		else:
			$HamsterArea.monitoring = false

func _physics_process(delta):
	if force > Vector2.ZERO:
		is_moving = true
	else:
		is_moving = false
	force = lerp(force, Vector2.ZERO, 0.04)
	global_position += force * 12 * delta



func _on_hamster_area_body_entered(body):
	Game.request_kill_hamster(body.name)
