extends CharacterBody2D
class_name Hamster

signal poop_count_changed(count)
signal nut_count_changed(count)

# movement vars
var speed := 300.0
var speed_reduction_rate := 50000
var max_speed := 400.0
var min_speed := 100.0
var accel := 0.0
@export var max_accel := 0.18
const TRESHOLD = 50.0
var controlling := true

# ability vars
var max_poop = 10
@export var poop_count := 0:
	set(value):
		poop_count = value
		emit_signal('poop_count_changed', poop_count)

var max_nut = 30
@export var nut_count := 0:
	set(value):
		nut_count = value
		emit_signal('nut_count_changed', nut_count)


# mass vars
var base_mass = 100
var mass_reduction_rate = 8
var mass_factor = (1-(log(base_mass-(base_mass-1))/mass_reduction_rate))
@export var mass = 100

#var growth_rate = 0.2
#var shrink_rate = 0.001
#var poison_shrink_rate = 0.01

# poop & nut preload
#var poop_scene: PackedScene = preload("res://objects/consumables/poop.tscn")
#var sun_seed_scene: PackedScene = preload("res://objects/consumables/sun_seed.tscn")
#var pumpkin_seed_scene: PackedScene = preload("res://objects/consumables/pumpkin_seed.tscn")

@export var username: String
@export var hamster_index: int

@onready var name_label = $Label
@onready var sprite = $Sprite2D
@onready var camera = $Camera2D
var zoom = 1

@onready var syncer = $MultiplayerSynchronizer

var blood_splat_scene = preload("res://scenes/objects/blood_splat.tscn")

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	camera.enabled = is_multiplayer_authority()
	
	if not is_multiplayer_authority():
		await syncer.synchronized
		display_hamster()

func _physics_process(delta):
	name_label.rotation = -rotation
#	speed = clamp(min_speed, -mass+max_speed+100, max_speed)
	speed = clamp(min_speed, max_speed+(speed_reduction_rate/mass)-(speed_reduction_rate/base_mass), max_speed)

	mass = max(mass - delta * mass/500, 100)
	scale = Vector2.ONE * ( (log(mass - (base_mass-1))/mass_reduction_rate) + mass_factor )
#	scale = Vector2.ONE * (mass/100)
	zoom = clamp(0, -scale.x+1+1 , 1)
	camera.zoom = Vector2.ONE * lerp(camera.zoom.x + delta, zoom, 0.5) * 1.2

#	print('speed: %s    mass: %s' %[speed, mass])
#	print(zoom)
#	print('mass: %s   scale: %s' %[mass, scale.x])
	
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
		
		if not obj.is_in_group('toy_ball'): return
		
		var dir = global_position.direction_to(obj.global_position)
		var force = dir * clamp(velocity.length(), 0, 100) 
		Game.rpc('move_toy_ball', obj.name, force)


func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	
	if not event is InputEventMouseButton: return
	
	if event.is_action_pressed("poop_attack") and poop_count > 0:
		var direction = Vector2.RIGHT.rotated(rotation) * -Vector2.ONE
		accel = 0.2
		Game.request_poop_attack(global_position, direction, get_multiplayer_authority())
		$Poop.play()
	
	if event.is_action_pressed("spit_nut") and nut_count > 0:
		var direction = Vector2.RIGHT.rotated(rotation)
		Game.request_spit_nut(global_position, direction, get_multiplayer_authority())
		$Spit.play()
  

func _notification(what):
	match what:
		NOTIFICATION_WM_MOUSE_ENTER:
			controlling = true
		NOTIFICATION_WM_MOUSE_EXIT:
			controlling = false


func set_hamster(username, hamster_index):
	self.username = username
	self.hamster_index = hamster_index
	display_hamster()
	

func display_hamster():
	name_label.text = username
	sprite.texture = HamsterData.hamsters[hamster_index].hamster_default
	

func get_mouse_dir() -> Vector2:
	if !controlling: return Vector2.ZERO
	return global_position.direction_to(get_global_mouse_position())


func _on_pickup_area_area_entered(area:Consumable):
#	if not is_multiplayer_authority(): return
	if area.spitter == get_multiplayer_authority(): return
	if is_multiplayer_authority():
		if get_angle_to(area.global_position) <= deg_to_rad(90) and \
			get_angle_to(area.global_position) >= deg_to_rad(-90):
			calculate_mass_eat(area)
			Game.request_despawn_pickup(area.name, get_multiplayer_authority())
			$Eat.play()


func _on_prey_area_body_entered(body: Hamster):
	if body.name == self.name: return
	
	if body.mass == self.mass: return
	
	if body.mass < self.mass:
		Game.request_hunt_hamster(str(self.name).to_int(), str(body.name).to_int())
	else:
		Game.request_hunt_hamster(str(body.name).to_int(), str(self.name).to_int())

func freeze_hamster():
	died()
	set_physics_process(false)
#	sprite.hide()
	sprite.texture = HamsterData.hamsters[hamster_index].hamster_died
	$CollisionShape2D.disabled = true
	$PickupArea/CollisionShape2D.disabled = true
	$PreyArea/CollisionShape2D.disabled = true
	$Timer.stop()
#	await Queries.update_player(str(self.name).to_int(), {'in_game': false})

func calculate_mass_eat(consumable):
	if consumable.is_in_group('poop'):
		mass += mass * consumable.mass / 100
#		print_debug(consumable.mass)
#		poisoned()
		rpc('poisoned')
	else:
		mass += consumable.mass

	if mass <= 100:
		mass = 100

	if consumable.is_in_group('nut') and nut_count < max_nut:
		nut_count += 1

	tween_scale()

func calculate_mass_release(consumable):
	print('mass release ', consumable.mass)
	if consumable.is_in_group('poop'):
		mass -= abs(consumable.mass) / 100
		poop_count -= 1
	else:
		mass -= consumable.mass
		nut_count -= 1

	if mass <= 100:
		mass = 100

	tween_scale()

func add_mass(num):
	mass += num / 5
	tween_scale()
	print('mass: ', mass)
	print('scale: ', scale)
	
@rpc("call_local")
func poisoned():
	$Poison.play()
	var tween = create_tween()
	tween.tween_property(sprite, 'modulate', Color(0.85, 0.66, 1, 1), 0.2)
	tween.tween_property(sprite, 'modulate', Color(1, 1, 1, 1), 0.2)
	tween.tween_property(sprite, 'modulate', Color(0.85, 0.66, 1, 1), 0.2)
	tween.tween_property(sprite, 'modulate', Color(1, 1, 1, 1), 0.2)

func died():
	$Die.play()
	var blood = blood_splat_scene.instantiate()
	add_child(blood)
	# splat blood

func tween_scale():
	var tween = create_tween()
#	var final_scale = Vector2.ONE * (mass ** growth_rate)
#	var final_scale = Vector2.ONE * (mass / 100)
	var final_scale = Vector2.ONE * ( (log(mass-(base_mass-1))/mass_reduction_rate) + mass_factor )
	tween.tween_property(self, "scale", final_scale, 0.5)


func _on_timer_timeout():
	if poop_count >= max_poop: return
	poop_count += 1
