extends Node2D

@onready var syncer = $MultiplayerSynchronizer

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

# Called when the node enters the scene tree for the first time.
func _ready():
#	syncer.set_multiplayer_authority(str(name).to_int())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
