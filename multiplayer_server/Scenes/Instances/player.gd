extends Node2D

@export var mass: float
@export var username: String
@export var hamster_index: int

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	await $MultiplayerSynchronizer.synchronized
	rpc_id(str(name).to_int(), 'set_start_pos', Game.get_player_pos())

@rpc
func set_start_pos(): pass
	

@rpc
func poisoned(): pass
