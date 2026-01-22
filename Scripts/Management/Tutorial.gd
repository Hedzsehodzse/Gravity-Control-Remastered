extends Node2D

var text_to_display: String
var current: int = 0
var count: int = 0
var timer: float = 0

var Task_Counter: int = 1

var Stars_Collected: int = 0


func _ready() -> void:
	Display_Text("Welcome to gravity control! Select the control input. You can change this any time from the pause menu (ESC)!")
	
	for star in $"../Stars".get_children():
		star.global_position.x += 5000
		
	for i in range(9, 24):
		$"../Nav/Stuff".get_child(i).global_position.x -= 5000
		


func _process(delta: float) -> void:
	timer += delta
	if timer > 0.05:
		if current < count:
			$Panel_1/Text.text += text_to_display[current]
			current += 1
		else:
			$Typing.stop()
		timer = 0


func Display_Text(text: String):
	$Panel_1/Text.text = ""
	text_to_display = text
	count = text.length()
	current = 0
	$Typing.play()


func Button_Pressed() -> void:
	Next_Task()
	$"..".Play_Sound(load("res://Sounds/UI_Button.mp3"), 0, global_position)
	
func Next_Task():
	match Task_Counter:
		1:
			Display_Text("Test the different kinds of surfaces!")
			$"../Nav/Stuff/A1".global_position.y = 206
			$"../Nav/Stuff/A2".global_position.y = 206
			$"../Nav/Stuff/A3".global_position.y = 206
			$"../Nav/Stuff/A4".global_position.y = 206
			$"../Nav/Stuff/A5".global_position.y = -210
		2:
			Display_Text("Try to collect the stars!")
			Set_Stars()
			$Panel_1/Button.visible = false
		3:
			Display_Text("Now do the same thing but with an extra twist!")
			for i in range(9, 24):
				$"../Nav/Stuff".get_child(i).global_position.x += 5000
			for star in $"../Stars".get_children():
				if star is Area2D:
					star.tres = 10
			Set_Stars()
		4:
			Display_Text("You have already learned the basics. It's better to start out with easier levels or the playground mode...")
			$Panel_1/Button.visible = true
		5:
			Display_Text("While playing you should avoid everything colored red since those objects kill you...")
		6:
			Display_Text("The chase game mode has weapons which you can freely test in playground mode...")
		7:
			Display_Text("While playing you can press ESC to pause the game and ENTER to hide the UI.")
		8:
			Display_Text("You can shoot with LEFT CLICK and restar the level with SPACE.")
		9:
			Display_Text("That's all for now, have fun!")
		10:
			get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
	
	Task_Counter += 1


func Set_Stars():
	var num = 0
	for node in $"../Stars".get_children():
		node.global_position.x -= 5000
		num += 1
		if num == 12:
			break
