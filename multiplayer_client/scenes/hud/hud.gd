extends CanvasLayer


@onready var hamster_profile = $MarginContainer/PlayerInfo/PlayerData/Profile
@onready var poop_gauge_label = $MarginContainer/PlayerInfo/PlayerData/Gauges/PoopGauge/PanelContainer/Label
@onready var nut_gauge_label = $MarginContainer/PlayerInfo/PlayerData/Gauges/NutGauge/PanelContainer/Label

@export var team_data: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_hud():
	hamster_profile.texture = HamsterData.hamsters[PlayerData.chosen_hamster_index].profile
	poop_gauge_label.text = str(0)
	nut_gauge_label.text = str(0)
	if PlayerData.team == null:
		team_data.hide()
	else:
		team_data.show()


func on_Player_poop_count_changed(value):
	poop_gauge_label.text = str(value)
	pass
	

func on_Player_nut_count_changed(value):
	nut_gauge_label.text = str(value)
	pass
