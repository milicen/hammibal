extends CanvasLayer


@onready var hamster_profile = $MarginContainer/PlayerInfo/PlayerData/Profile
@onready var poop_gauge_label = $MarginContainer/PlayerInfo/PlayerData/Gauges/PoopGauge/PanelContainer/Label
@onready var nut_gauge_label = $MarginContainer/PlayerInfo/PlayerData/Gauges/NutGauge/PanelContainer/Label

@export var team_data: Control
@export var team_code: Control

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
		team_code.hide()
	else:
		team_data.show()
		team_code.show()
		team_code.get_child(1).text = PlayerData.team

func set_team():
	var members = Game.team_members.duplicate(true).filter(func(mem): return mem.id != multiplayer.get_unique_id())
	var profiles = team_data.get_children()
	var offset = 0
	for i in profiles.size():
		var index = i + offset
		if index < members.size():
			if members[index].id == multiplayer.get_unique_id():
				offset += 1
				continue
			profiles[i].set_data(members[index])
		else:
			profiles[i].set_data(null)


func on_Player_poop_count_changed(value):
	poop_gauge_label.text = str(value)
	pass
	

func on_Player_nut_count_changed(value):
	nut_gauge_label.text = str(value)
	pass
