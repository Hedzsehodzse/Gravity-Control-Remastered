extends Node2D


enum modes {SURVIVAL, CHASE}
@export var Game_Mode: modes
@export var Survive_Time: float = 30
@onready var timer: float = Survive_Time
var gravity: Vector2 = Vector2(0, 400)
var won: bool = false
var lost: bool = false
var text_times: int = 0
var Enemy_Count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music_Finished()
	%Win.visible = false
	
	if Game_Mode == modes.SURVIVAL:
		%Txt_Timer.wait_time = Survive_Time / 3
		%Txt_Timer.start()
		Text_Timeout()
		%Reload.visible = false
	
	if Game_Mode == modes.CHASE:
		for node in get_children():
			if node.is_in_group("Enemy"):
				Enemy_Count += 1
		%Time.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Space"):
		get_tree().reload_current_scene()
		
	if !lost and !won:
		
		if Game_Mode == modes.SURVIVAL:
			timer -= delta
			%Time.bbcode_text = "[center]" + str(roundi(timer))
			if timer < 8 and !%Clock.playing:
				%Clock.play()
			if timer < 0:
				Win()
				
		if Game_Mode == modes.CHASE:
			if Enemy_Count == 0:
				Win()

func Win():
	if !won:
		won = true
		print("WON")
		for node in get_children():
			if node.is_in_group("Enemy"):
				node.Die()
		%Win/Title.modulate = Color.LIME_GREEN
		%Win/Title.bbcode_text = "[center]Victory!"
		Panel_Anim()
		%Clock.stop()
		Play_Sound(load("res://Sounds/Win.mp3"), 0, %Ball.global_position)
	
func Lose():
	if !lost:
		lost = true
		%Win/Title.modulate = Color.RED
		%Win/Title.bbcode_text = "[center]Defeat!"
		print("LOST")
		Panel_Anim()
		%Clock.stop()
		Play_Sound(load("res://Sounds/Lose.mp3"), -5, %Ball.global_position)


func Text_Timeout() -> void:
	var tween: Tween = create_tween()
	match text_times:
		0:
			tween.tween_property(%Time, "modulate", Color.YELLOW, Survive_Time / 3)
			text_times += 1
		1:
			tween.tween_property(%Time, "modulate", Color.ORANGE, Survive_Time / 3)
			text_times += 1
		2:
			tween.tween_property(%Time, "modulate", Color.RED, Survive_Time / 3)
			
func Panel_Anim():
	%Time.bbcode_text = "¤"
	%Win.position = get_viewport().get_canvas_transform() * %Ball.global_position
	%Win/Anim.play("Fade")
	var tween = create_tween()
	tween.tween_property(%Win, "position", Vector2(775, 381), 0.3)


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
