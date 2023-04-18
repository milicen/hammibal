extends Node

var poop = preload("res://Scenes/Instances/consumable/poop.tscn")

var sun_seed = preload("res://Scenes/Instances/consumable/sun_seed.tscn")
var pumpkin_seed = preload("res://Scenes/Instances/consumable/pumpkin_seed.tscn")

#client porject calls
@rpc("any_peer")
func receive_poop_attack(position, direction, size, rotation, consumable_name, requester_id):
	pass

@rpc("any_peer")
func receive_spit_nut(position, direction, size, rotation, consumable_name, requester_id):
	pass

# server project calls
@rpc("any_peer")
func process_poop_attack(position, direction, requester_id): 
	var p = poop.instantiate()
	p.set_multiplayer_authority(requester_id)
	get_node("/root/Main").add_child(p, true)
	var rand_size = randf_range(0.4, 0.6)
	var rand_rotation = randf_range(0, 2*PI)
	rpc('receive_poop_attack', position, direction, rand_size, rand_rotation, p.name, requester_id)

@rpc("any_peer")
func process_spit_nut(position, direction, requester_id):
	var rand = randi() % 2
	var nut = sun_seed.instantiate() if rand == 0 else pumpkin_seed.instantiate()
	nut.set_multiplayer_authority(requester_id)
	get_node('/root/Main').add_child(nut, true)
	var rand_size = randf_range(0.4, 0.6)
	var rand_rotation = randf_range(0, 2*PI)
	rpc('receive_spit_nut', position, direction, rand_size, rand_rotation, nut.name, requester_id)
