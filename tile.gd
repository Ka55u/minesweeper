extends Button

signal bomb_revealed

var is_bomb = false
var is_revealed = false
var is_flagged = false
var nearby_bombs = 0
var grid_x = 0
var grid_y = 0

const BOMB = preload("res://assets/Bomb.png")
const BACK_IMAGE = preload("res://assets/Hidden.png")
const FLAGGED = preload("res://assets/Flagged.png")
const EMPTY = preload("res://assets/Empty.png")
const EXPLOSION = preload("res://assets/Explosion.png")
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var grid_select_player: AudioStreamPlayer = $Grid_select_player
@onready var flag_place_player: AudioStreamPlayer = $flag_place_player
@onready var tile: Button = self

func _ready():
	icon = BACK_IMAGE
	set_focus_mode(FocusMode.FOCUS_ALL)
	add_theme_stylebox_override("disabled", get_theme_stylebox("normal"))
	if not is_connected("pressed", Callable(self, "_on_left_click")):
		connect("pressed", Callable(self, "_on_left_click"))
	

#listens to flag input from left mouse button and keyboard buttons
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			flag_toggle()
			accept_event()
	elif has_focus() and event is InputEventKey	and event.pressed:
		if event.keycode == KEY_ENTER:
			reveal()
			accept_event()
		elif event.keycode == KEY_SPACE:
			flag_toggle()
			accept_event()

#listens to right mouse button, works with signal, calls main function to reveal tiles
func _on_left_click():
	grid_select_player.play()
	var main = get_parent().get_parent().get_parent()
	main._on_tile_clicked(self)
	

func reveal():
	if is_revealed or is_flagged:
		return
	is_revealed = true
	print("revealed")
	if is_bomb:
		print("bomb")
		icon = BOMB
		if GlobalVar.first_bomb == true:
			GlobalVar.first_bomb = false
			await get_tree().create_timer(1.0).timeout
			audio_stream_player.play()
			icon = EXPLOSION
		emit_signal("bomb_revealed")
	else:
		icon = EMPTY
		if nearby_bombs > 0:
			text = str(nearby_bombs)
		else:
			text = ""
		disabled = true
	
func flag_toggle():
	if is_revealed:
		return
	is_flagged = not is_flagged
	if is_flagged:
		flag_place_player.play()
		icon = FLAGGED
	else:
		
		icon = BACK_IMAGE
