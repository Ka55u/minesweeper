extends Control

@onready var play: Button = $VBoxContainer/Play
@onready var exit: Button = $VBoxContainer/Exit
@onready var menu_tic_player: AudioStreamPlayer = $Menu_tic_player
@onready var hard_mode: CheckButton = $HardMode


var menu_items = []
var current_index = 0

func _ready():
	GlobalVar.is_hard = false
	menu_items = [play, exit, hard_mode]
	menu_items[current_index].grab_focus()
	
#implementing menu navigation with tab or arrow keys
func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_TAB or event.keycode == KEY_DOWN or event.keycode == KEY_RIGHT:
			current_index = (current_index + 1) % menu_items.size()
			menu_items[current_index].grab_focus()
			accept_event()
		elif event.keycode == KEY_UP or event.keycode == KEY_LEFT:
			current_index = (current_index - 1 + menu_items.size()) % menu_items.size()
			menu_items[current_index].grab_focus()
			accept_event()
		elif event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			print(menu_items[current_index])
			if menu_items[current_index] == play:
				_on_play_clicked()
			elif menu_items[current_index] == exit:
				_on_exit_clicked()
			elif menu_items[current_index] == hard_mode:
				hard_mode.toggle_mode = !hard_mode.toggle_mode
				_on_hardmode_toggled(hard_mode.toggle_mode)
			accept_event()
		elif event.keycode == KEY_ESCAPE:
			_on_exit_clicked()
			accept_event()
			
func _on_play_hovered():
	menu_tic_player.play()
	
func _on_exit_hovered():
	menu_tic_player.play()

func _on_hardmode_toggled(mode):
	if mode == true:
		hard_mode.text = "Hard"
		GlobalVar.is_hard = true
	elif mode == false:
		hard_mode.text = "Easy"
		GlobalVar.is_hard = false
	print(GlobalVar.is_hard)

#play button input
func _on_play_clicked():
	menu_tic_player.play()
	get_tree().change_scene_to_file("res://Minesweeper.tscn")

#exitbutton input
func _on_exit_clicked():
	menu_tic_player.play()
	get_tree().quit()
