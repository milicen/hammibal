extends Node2D


@export var username: String
@export var hamster_index: int

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

@rpc
func poisoned(): pass
