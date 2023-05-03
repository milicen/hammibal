extends TextureRect


#var rank
#var player_name
#var mass

@onready var rank_label = $MarginContainer/HBoxContainer/RankLabel
@onready var player_name_label = $MarginContainer/HBoxContainer/PlayerNameLabel
@onready var mass_label = $MarginContainer/HBoxContainer/MassLabel


func set_list_data(rank, player_name, mass):
	rank_label.text = str(rank)
	player_name_label.text = player_name
	mass_label.text = str(mass)
