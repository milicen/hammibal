extends Node2D

@export var mass: float = 1
@export var spitter: int = -1
@export var direction: Vector2
@export var is_moving := false

var speed: float = 1000.0
var velocity := Vector2.ZERO
var start_pos := Vector2.ZERO


func _ready():
	global_position = start_pos
	
	if spitter < 0:
		set_physics_process(false)
		return
	
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

func init(spitter: int, start_position: Vector2, direction: Vector2, rand_size: float, rand_rotation: float):
	self.spitter = spitter
	self.direction = direction
	mass *= rand_size
	scale *= rand_size
	start_pos = start_position
	rotation = rand_rotation

func _on_timer_timeout():
	is_moving = false
	spitter = -1
