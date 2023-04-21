extends CharacterBody2D
class_name Hamster

# movement vars
var speed := 300.0
var accel := 0.0
@export var max_accel := 0.18
const TRESHOLD = 50.0
var controlling := true

# ability vars
@export var poop_count := 100
@export var nut_count := 100
@export var nut_mod := 0

# mass vars
var mass = 1
var growth_rate = 0.2
var shrink_rate = 0.001
var poison_shrink_rate = 0.01

# poop & nut preload
#var poop_scene: PackedScene = preload("res://objects/consumables/poop.tscn")
#var sun_seed_scene: PackedScene = preload("res://objects/consumables/sun_seed.tscn")
#var pumpkin_seed_scene: PackedScene = preload("res://objects/consumables/pumpkin_seed.tscn")

@onready var sprite = $Sprite2D
@onready var camera = $Camera2D

@onready var syncer = $MultiplayerSynchronizer

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
#	syncer.set_multiplayer_authority(str(name).to_int())
	camera.enabled = is_multiplayer_authority()

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	
	var direction = get_mouse_dir()
	var distance = global_position.distance_to(get_global_mouse_position())
	
	accel = lerp(accel, 0.0, 0.1)
	if accel > 0:
		velocity += accel * direction * speed
	
	if distance > TRESHOLD:
		velocity = lerp(velocity, direction * speed, 0.05)
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.1)

	rotation = velocity.angle()
	# if colliding with somwthing
	if move_and_slide():
		var coll = get_last_slide_collision()
		var obj = coll.get_collider()
		var dir = global_position.direction_to(obj.global_position)
		var force = dir * clamp(velocity.length(), 0, 100) 
		Game.rpc('move_toy_ball', obj.name, force)


func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	
	if not event is InputEventMouseButton: return
	
	if event.is_action_pressed("poop_attack"):
		var direction = Vector2.RIGHT.rotated(rotation) * -Vector2.ONE
		accel = 0.2
		Game.request_poop_attack(global_position, direction, get_multiplayer_authority())
	
	if event.is_action_pressed("spit_nut"):
		var direction = Vector2.RIGHT.rotated(rotation)
		Game.request_spit_nut(global_position, direction, get_multiplayer_authority())
  

func _notification(what):
	match what:
		NOTIFICATION_WM_MOUSE_ENTER:
			controlling = true
		NOTIFICATION_WM_MOUSE_EXIT:
			controlling = false


func get_mouse_dir() -> Vector2:
	if !controlling: return Vector2.ZERO
	return global_position.direction_to(get_global_mouse_position())


func _on_pickup_area_area_entered(area:Consumable):
#	if not is_multiplayer_authority(): return
	if area.spitter == get_multiplayer_authority(): return
	if is_multiplayer_authority():
		print('eat')
		Game.request_despawn_pickup(area.name, get_multiplayer_authority())

func _on_prey_area_body_entered(body: Hamster):
	if body.name == self.name: return
	
	if body.mass == self.mass: return
	
	if body.mass < self.mass:
		Game.request_hunt_hamster(str(self.name).to_int(), str(body.name).to_int())
	else:
		Game.request_hunt_hamster(str(body.name).to_int(), str(self.name).to_int())


func calculate_mass_eat(consumable):
	if consumable.consumable_name == 'poop':
		mass += mass * consumable.mass / 100
	else:
		mass += consumable.mass

	if consumable.is_in_group('nut'):
		nut_count += 1

	tween_scale()

func calculate_mass_release(consumable):
	print('mass release ', consumable.mass)
	if consumable.consumable_name == 'poop':
		mass += mass * consumable.mass / 100
		poop_count -= 1
	else:
		mass -= consumable.mass
		nut_count += 1

	tween_scale()

func add_mass(num):
	mass += num
	tween_scale()

func tween_scale():
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	var final_scale = Vector2.ONE * (mass ** growth_rate)
	tween.tween_property(self, "scale", final_scale, 0.3)






