extends CharacterBody2D

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
	move_and_slide()

func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	
	if not event is InputEventMouseButton: return
	
	if event.is_action_pressed("poop_attack"):
		var direction = Vector2.RIGHT.rotated(rotation) * -Vector2.ONE
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

#@rpc("call_local","any_peer")
#func poop_attack() -> void:
#	if poop_count < 1: return
#
#	accel = max_accel
#	poop_count -= 1
##	var direction = get_mouse_dir() * -Vector2.ONE
#	var direction = Vector2.RIGHT.rotated(rotation) * -Vector2.ONE
#	var poop = instance_poop(direction)
#	mass -= poop.mass / poop.mass - 0.8
#	tween_scale()
#	get_parent().rpc_id(1, 'spawn_pickup', str(name).to_int(), global_position, direction)

#@rpc("call_local")
#func instance_poop(direction:Vector2) -> Consumable:
#	var poop:Consumable = poop_scene.instantiate()
#	poop.init(self, global_position, direction)
#	get_parent().add_child(poop, true)
#	return poop
	
#@rpc("call_local")
#func spit_nut() -> void:
#	if nut_count < 1: return
	
#	nut_count -= 1
#	var direction = get_mouse_dir()
#	var direction = Vector2.RIGHT.rotated(rotation)
#	var nut = instance_nut(direction)
#	mass -= nut.mass
#	tween_scale()
	
#@rpc("call_local")
#func instance_nut(direction:Vector2) -> Consumable:
#	var rand = randi() % 2
#	nut_mod = (nut_mod+1) % 2
#	var nut
#	if nut_mod == 0:
#		nut = sun_seed_scene.instantiate()
#	else:
#		nut = pumpkin_seed_scene.instantiate()
#	nut.init(self, global_position, direction)
#	get_parent().add_child(nut, true)
#	return nut

func get_mouse_dir() -> Vector2:
	if !controlling: return Vector2.ZERO
	return global_position.direction_to(get_global_mouse_position())


#func _on_pickup_area_area_entered(area:Consumable):
#	if area.spitter == get_multiplayer_authority(): return
#
#	if area.consumable_name == 'poop':
#		mass += mass * area.mass / 100
#	else:
#		mass += area.mass
#
#	if area.is_in_group('nut'):
#		nut_count += 1
#
#	tween_scale()
#
#	area.despawn()

func tween_scale():
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	var final_scale = Vector2.ONE * (mass ** growth_rate)
	tween.tween_property(self, "scale", final_scale, 0.3)











