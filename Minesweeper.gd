extends Node2D

@onready var grid_size = 10
@onready var bomb_count = 10
const EXPLOSION = preload("res://assets/Explosion.png")

var grid = []
var score_count = 0

@onready var grid_container: GridContainer = $Control/GridContainer
@onready var status: Label = $Status
@onready var score: Label = $Score
@onready var to_menu: Button = $ToMenu


func _ready():
	GlobalVar.first_bomb = true
	to_menu.visible = false
	status.text = "Welcome to minesweeper!"
	randomize()
	create_grid()
	place_bombs()
	calculate_nearby_bombs()
	

func create_grid():
	#logic for creating the grid
	grid_container.columns = grid_size
	for i in range(grid_size * grid_size):
		var tile_scene = preload("res://Tile.tscn")
		var tile = tile_scene.instantiate()
		
		#connecting bombs through a signal to handle game over
		tile.connect("bomb_revealed", Callable(self, "_on_bomb_revealed"))
		grid.append(tile)
		grid_container.add_child(tile)
		
	if grid.size() > 0:
		grid[0].grab_focus()

#placing bombs in the grid
func place_bombs():
	var bombs_placed = 0
	while bombs_placed < bomb_count:
		var index = randi() % (grid_size * grid_size)
		var tile = grid[index]
		if not tile.is_bomb:
			tile.is_bomb = true
			bombs_placed += 1
			
func calculate_nearby_bombs():
	for x in range(grid_size):
		for y in range(grid_size):
			var index = x + y * grid_size
			var tile = grid[index]
			if tile.is_bomb:
				continue
			var count = 0
			for dx in range(-1, 2):
				for dy in range(-1, 2):
					if dx == 0 and dy == 0:
						continue
					var nx = x + dx
					var ny = y + dy
					if nx >= 0 and nx < grid_size and ny >= 0 and ny < grid_size:
						var neighbor_index = nx + ny * grid_size
						if grid[neighbor_index].is_bomb:
							count += 1
					tile.nearby_bombs = count

func _on_bomb_revealed():
	game_over()
	
func game_over():
	for tile in grid:
		tile.mouse_filter = grid_container.MOUSE_FILTER_IGNORE
		if tile.is_bomb and not tile.is_revealed:
			tile.reveal()
	status.text = "GAME OVER!"
	to_menu.visible = true
	
#checks for win condition when all non bomb tiles are revealed
func win_condition():
	var unrevealed = 0
	for tile in grid:
		if not tile.is_revealed and not tile.is_bomb:
			unrevealed += 1
	if unrevealed == 0:
		status.text = "VICTORY!"
		to_menu.visible = true
		
func _on_to_menu_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")
		
#input handling for arrow keys, navigation in grid
func _unhandled_input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		var current_tile = null
		#find tile that has focus
		for tile in grid:
			if tile.has_focus():
				current_tile = tile
				break
		if current_tile:
			var index = grid.find(current_tile)
			var x = index % grid_size
			var y = index / grid_size
			if event.keycode == KEY_UP and y > 0:
				grid[index - grid_size].grab_focus()
				event.accept()
			elif event.keycode == KEY_DOWN and y < grid_size - 1:
				grid[index + grid_size].grab_focus()
				event.accept()
			elif event.keycode == KEY_LEFT and x > 0:
				grid[index - 1].grab_focus()
				event.accept()
			elif event.keycode == KEY_RIGHT and x < grid_size - 1:
				grid[index + 1].grab_focus()
				event.accept()
				
