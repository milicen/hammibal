extends VBoxContainer

@export var input: LineEdit
@export var join_btn: Button
@export var root: Control

signal join_game(host_type)


func is_btn_disabled() -> bool:
	return join_btn.disabled == true


func toggle_join_btn(disabled:bool):
	if disabled:
		join_btn.disabled = true
		join_btn.mouse_filter = MOUSE_FILTER_IGNORE
	else:
		join_btn.disabled = false
		join_btn.mouse_filter = MOUSE_FILTER_STOP


func _on_player_name_input_text_changed(new_text):
	if new_text != '' and is_btn_disabled():
		toggle_join_btn(false)
		return
	
	if new_text == '' and !is_btn_disabled():
		toggle_join_btn(true)
		return

func _on_player_name_input_focus_exited():
	if join_btn.is_hovered(): return
	Game.request_update_player_data('username', input.text, multiplayer.get_unique_id())
	pass # Replace with function body.


func _on_join_game_button_pressed():
	Game.request_update_player_data('username', input.text, multiplayer.get_unique_id())
	await Game.update_player_finished
	AudioManager.play_btn()
	emit_signal('join_game')



