extends Node2D

var gravity: Vector2 = Vector2(0, 400)
var selected: Node
enum modes {SURVIVAL, CHASE, PLAYGROUND, COLLECT}

const SAVE_FILE = "user://save_data_gc.txt"
var save: Dictionary = { "Selected" = modes.COLLECT,
						"Levels" = {}
}

@export var Colors: PackedColorArray

func _ready() -> void:
	get_tree().paused = false
	
	Music_Finished()
	
	load_game()
	save_game()

func Timeout() -> void:
	Spawn_Saw($Pos.global_position)
	Spawn_Saw($Pos2.global_position)
	
func Spawn_Saw(pos: Vector2):
	var saw = load("res://Scenes/Enemies/Saw.tscn").instantiate()
	add_child(saw)
	saw.global_position = pos
	saw.time = 10
	
func Music_Finished() -> void:
	var num = randi_range(1, 2)
	var stream: Resource
	if num == 1:
		stream = load("res://Sounds/Music2(ZapSplat).mp3")
	else:
		stream = load("res://Sounds/Music1(ZapSplat).mp3")
	%Music.stream = stream
	%Music.playing = true
	
func Play_Sound(stream: Resource, volume_db: float, pos: Vector2):
	var player = AudioStreamPlayer2D.new()
	add_child(player)
	player.global_position = pos
	player.volume_db = volume_db
	player.stream = stream
	player.playing = true
	var tween = create_tween()
	tween.tween_callback(player.queue_free).set_delay(5)

func Play() -> void:
	$UI/Main.visible = false
	$UI/Levels.visible = true
	Play_Sound(load("res://Sounds/Accept.mp3"), 0, Vector2.ZERO)

func Quit() -> void:
	Play_Sound(load("res://Sounds/UI.mp3"), 0, Vector2.ZERO)
	get_tree().quit()

func Back() -> void:
	$UI/Main.visible = true
	$UI/Levels.visible = false
	$UI/Preview.visible = false
	Play_Sound(load("res://Sounds/UI.mp3"), 0, Vector2.ZERO)
	
func Select_Level(node: Node):
	selected = node
	if !$UI/Preview.visible:
		$UI/Preview/Anim.play("In")
		$UI/Preview.visible = true
	$UI/Preview/Image.texture = node.Sprite
	$UI/Preview/Title.bbcode_text = "[center]" + node.Name
	$UI/Preview/Diff.text = node.current_diff
	$UI/Preview/Diff.modulate = node.get_node("Difficulty").modulate
	Play_Sound(load("res://Sounds/UI.mp3"), 0, Vector2.ZERO)

func Go_To_Level() -> void:
	Play_Sound(load("res://Sounds/Accept.mp3"), 0, Vector2.ZERO)
	get_tree().change_scene_to_file(selected.Scene)

func Item_Selected(index: int) -> void:
	match index:
		0:
			for level in $UI/Levels/VScrollBar/Container.get_children():
				level.Display_Difficulty(level.modes.COLLECT)
				save["Selected"] = modes.COLLECT
				$UI/Preview/Mode.text = "Mode: Collect"
		1:
			for level in $UI/Levels/VScrollBar/Container.get_children():
				level.Display_Difficulty(level.modes.CHASE)
				save["Selected"] = modes.CHASE
				$UI/Preview/Mode.text = "Mode: Chase"
		2:
			for level in $UI/Levels/VScrollBar/Container.get_children():
				level.Display_Difficulty(level.modes.SURVIVAL)
				save["Selected"] = modes.SURVIVAL
				$UI/Preview/Mode.text = "Mode: Survival"
		3:
			for level in $UI/Levels/VScrollBar/Container.get_children():
				level.Display_Difficulty(level.modes.PLAYGROUND)
				save["Selected"] = modes.PLAYGROUND
				$UI/Preview/Mode.text = "Mode: Playground"
				
	if selected != null:
		Select_Level(selected)
	save_game()
	
	Play_Sound(load("res://Sounds/UI.mp3"), 0, Vector2.ZERO)

func load_game():
	if FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			
			if parse_result == OK:
				save = json.data
				print("Game loaded!")
				print("")
				print(save)
				print("")
			else:
				print("Failed to parse save file")
	else:
		print("No save file found, using defaults")
		
	save["Selected"] = modes.COLLECT
	if !save.has("Levels"):
		save["Levels"] = {}
	for level in $UI/Levels/VScrollBar/Container.get_children():
		if !save["Levels"].has(level.Name):
			save["Levels"][level.Name] = {}
			save["Levels"][level.Name]["Survival"] = false
			save["Levels"][level.Name]["Chase"] = false
			save["Levels"][level.Name]["Collect"] = false
			
		if !save["Levels"][level.Name].has("Survival_Attempts"):
			save["Levels"][level.Name]["Survival_Attempts"] = 0
			save["Levels"][level.Name]["Chase_Attempts"] = 0
			save["Levels"][level.Name]["Collect_Attempts"] = 0
			
		level.Colors = Colors
		level.Display_Difficulty(modes.COLLECT)

func save_game():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save))
		print("Game saved!")
	else:
		print("Failed to save game")


func Tutorial() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Tutorial.tscn")
