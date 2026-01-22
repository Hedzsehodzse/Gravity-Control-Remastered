extends CanvasLayer


@onready var Main: Node = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Main.Game_Mode == Main.modes.CHASE or Main.Game_Mode == Main.modes.PLAYGROUND:
		$Selection/Anim.play("Fade")
	else:
		get_tree().paused = false
		
func _process(_delta: float) -> void:
	$FPS.bbcode_text = "[center]" + str(roundi(Engine.get_frames_per_second()))
	
	if Input.is_action_just_pressed("Enter"):
		if visible:
			visible = false
		else:
			visible = true
			
	if Input.is_action_just_pressed("Escape"):
		if $Pause.visible:
			Un_Pause()
		else:
			Pause()
		

func Timeout() -> void:
	_ready()


func Play_Sound(stream: Resource, volume_db: float, pos: Vector2):
	var player = AudioStreamPlayer2D.new()
	add_child(player)
	player.global_position = pos
	player.volume_db = volume_db
	player.stream = stream
	player.playing = true
	var tween = create_tween()
	tween.tween_callback(player.queue_free).set_delay(5)
	
func Pause():
	$Pause.visible = true
	get_tree().paused = true
	
func Un_Pause():
	$Pause.visible =  false
	get_tree().paused =  false


func Resume() -> void:
	Un_Pause()
	Play_Sound(load("res://Sounds/Accept.mp3"), 0, Vector2.ZERO)


func Menu() -> void:
	Play_Sound(load("res://Sounds/UI.mp3"), 0, Vector2.ZERO)
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
	
	
func Quit() -> void:
	Play_Sound(load("res://Sounds/UI.mp3"), 0, Vector2.ZERO)
	get_tree().quit()


func Modes_Item_Selected(index: int) -> void:
	match index:
		0:
			%Ball.mouse_control = true
			Main.save["Settings"]["Control_Mode"] = "Mouse_Control"
			$Pause/Modes.selected = 0
			if Main.Tutorial:
				$"../Hover_Texts/Modes".selected = 0
		1:
			%Ball.mouse_control = false
			Main.save["Settings"]["Control_Mode"] = "W-A-S-D"
			$Pause/Modes.selected = 1
			if Main.Tutorial:
				$"../Hover_Texts/Modes".selected = 1
			
	Main.save_game()


func Value_Changed(value: float) -> void:
	Main.save["Settings"]["Music"] = value / 100
	Main.Set_Music()
	Main.save_game()
