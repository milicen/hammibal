extends Node


@export var max_spawn = 200

func _on_timer_timeout():
	if get_tree().get_nodes_in_group('consumable').size() < max_spawn:
		Game.spawn_consumable()
