extends Control

@onready var play: Button = $VBoxContainer/Play
@onready var exit: Button = $VBoxContainer/Exit

func _on_play_clicked():
	get_tree().change_scene_to_file("res://Minesweeper.tscn")

func _on_exit_clicked():
	get_tree().quit()
