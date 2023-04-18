extends Area2D
class_name Consumable

@export var consumable_name: String
@export var mass: float
@export var is_ability: bool
@export var speed: float = 1000.0
var spitter = null
var direction: Vector2
var is_moving := false
var velocity := Vector2.ZERO
var start_pos := Vector2.ZERO
@export var rand_rotation: float
@export var rand_size: float


@onready var sprite := $Sprite2D

func _ready():
	if not spitter:
		set_physics_process(false)
		return
	
	global_position = start_pos
	if is_ability:
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
	spitter = null

func despawn():
	if is_moving:
		call_deferred("queue_free")
		return
	
	await get_tree().create_timer(0.2).timeout
	call_deferred("queue_free")
