extends CharacterBody2D

@export var force: Vector2
@export var is_moving := false

func _physics_process(delta):
	if force > Vector2.ONE * 20:
		is_moving = true
	else:
		is_moving = false
	force = lerp(force, Vector2.ZERO, 0.04)
	velocity = force
	var coll_info = move_and_collide(velocity * 12 * delta)
	if coll_info:
		velocity = velocity.bounce(coll_info.get_normal())
		force = velocity
	rotation += velocity.length() * delta / 10
