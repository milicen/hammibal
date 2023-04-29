extends Node

var poop = preload("res://Scenes/Instances/consumable/poop.tscn")

var sun_seed = preload("res://Scenes/Instances/consumable/sun_seed.tscn")
var pumpkin_seed = preload("res://Scenes/Instances/consumable/pumpkin_seed.tscn")

var consumables = {
	'poop': preload("res://Scenes/Instances/consumable/poop.tscn"),
	'sun_seed': preload("res://Scenes/Instances/consumable/sun_seed.tscn"),
	'pumpkin_seed': preload("res://Scenes/Instances/consumable/pumpkin_seed.tscn"),
	'carrot': preload("res://Scenes/Instances/consumable/carrot.tscn"),
	'corn_a': preload("res://Scenes/Instances/consumable/corn_a.tscn"),
	'corn_b': preload("res://Scenes/Instances/consumable/corn_b.tscn"),
	'pomo_a': preload("res://Scenes/Instances/consumable/pomo_a.tscn"),
	'pomo_b': preload("res://Scenes/Instances/consumable/pomo_b.tscn"),
	'fetus': preload("res://Scenes/Instances/consumable/fetus.tscn"),
	'lettuce': preload("res://Scenes/Instances/consumable/lettuce.tscn"),
}

const MAP_POS = Vector2(-2077,-1563)
const MAP_SIZE = Vector2(5307+MAP_POS.x,3774+MAP_POS.y) 

#client porject calls
@rpc("any_peer")
func receive_poop_attack(consumable_name, requester_id): pass

@rpc("any_peer")
func receive_spit_nut(consumable_name, requester_id): pass

@rpc("any_peer")
func receive_hunt_hamster(hunter, prey): 	pass

@rpc("any_peer")
func receive_kill_hamster(hamster_name): pass

@rpc("any_peer","call_local")
func move_toy_ball(ball_name, force): 
	var ball = get_node("/root/Main/%s" % str(ball_name))
	ball.force = force

#@rpc("any_peer")
func spawn_consumable():
	var keys = consumables.keys()
	var key = keys[randi() % keys.size()]
	var consumable = consumables[key].instantiate()
	
	var rand_size = randf_range(0.4, 0.6)
	var rand_rotation = randf_range(0, 2*PI)
	var rand_x = randf_range(MAP_POS.x, MAP_SIZE.x)
	var rand_y = randf_range(MAP_POS.y, MAP_SIZE.y)
	var pos = Vector2(rand_x, rand_y)
	
	consumable.init(-1, pos, Vector2.ZERO, rand_size, rand_rotation)
	get_node("/root/Main").add_child(consumable, true)
	
	var _name: String = consumable.name
	var mod = _name.rstrip('1234567890')
	

# server project calls
@rpc("any_peer")
func process_poop_attack(position, direction, requester_id): 
	var p = poop.instantiate()
	var rand_size = randf_range(0.4, 0.6)
	var rand_rotation = randf_range(0, 2*PI)
	p.init(requester_id, position, direction, rand_size, rand_rotation)
	get_node("/root/Main").add_child(p, true)
	rpc('receive_poop_attack', p.name, requester_id)

@rpc("any_peer")
func process_spit_nut(position, direction, requester_id):
	var rand = randi() % 2
	var nut = sun_seed.instantiate() if rand == 0 else pumpkin_seed.instantiate()
	var rand_size = randf_range(0.4, 0.6)
	var rand_rotation = randf_range(0, 2*PI)
	nut.init(requester_id, position, direction, rand_size, rand_rotation)
	get_node('/root/Main').add_child(nut, true)
	rpc('receive_spit_nut', nut.name, requester_id)

@rpc("any_peer")
func process_despawn_pickup(pickup_name, requester_id):
	var pickup = get_node_or_null("/root/Main/%s" % str(pickup_name))
	if pickup:
		pickup.call_deferred('queue_free')


@rpc("any_peer")
func process_hunt_hamster(hunter, prey):
	var p_hamster = get_node_or_null("/root/Main/%s" % str(prey))
#	if p_hamster:
#		p_hamster.call_deferred('queue_free')
	rpc('receive_hunt_hamster', hunter , prey)

@rpc("any_peer")
func process_kill_hamster(hamster_name):
	var hamster = get_node("/root/Main/%s" % str(hamster_name))
#	hamster.call_deferred('queue_free')
	rpc('receive_kill_hamster', hamster_name)












