extends Area2D
class_name Consumable

@export var mass: float = 1.0
@export var spitter: int
@export var direction: Vector2
@export var is_moving := false


func _ready():
	hide()
	await self.ready
	await $MultiplayerSynchronizer.synchronized
	show()
	monitorable = true
