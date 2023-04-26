extends Area2D
class_name Consumable

@export var mass: float = 1.0
@export var spitter: int
@export var direction: Vector2
@export var is_moving := false

@export var consumable_name: String
@export var speed: float = 1000.0
var velocity := Vector2.ZERO
var start_pos := Vector2.ZERO


func _ready():
	if not spitter:
		set_physics_process(false)
		return
	
	global_position = start_pos
	if direction != Vector2.ZERO:
		set_physics_process(true)
		is_moving = true
	else:
		set_physics_process(false)
	

func _physics_process(delta):
	if is_moving:
		velocity = direction * speed * delta
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.2)
		
	global_position += velocity

func init(spitter, start_position: Vector2, direction: Vector2, rand_size: float, rand_rotation: float):
	self.spitter = spitter
	self.direction = direction
#	rand_size = randf_range(0.4, 0.6)
	mass *= rand_size
	scale *= rand_size
	start_pos = start_position
#	rand_rotation = randf_range(0, 2*PI)
	rotation = rand_rotation

func _on_timer_timeout():
	is_moving = false
	spitter = -1


func despawn():
	if is_moving:
		call_deferred("queue_free")
		return
	
	await get_tree().create_timer(0.2).timeout
	call_deferred("queue_free")
