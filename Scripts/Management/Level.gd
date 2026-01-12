extends Panel

enum modes {SURVIVAL, CHASE, PLAYGROUND, COLLECT}
enum difficulties {BEGINNER, EASY, MEDIUM, HARD, EXTREME, IMPOSSIBLE}

@export var Name: String
@export var Sprite: CompressedTexture2D
@export var Difficulty: Array[difficulties] 
@export var Scene: String
@export var Colors: PackedColorArray = []

var current_diff: String

@onready var Main = $"../../../../.."

func _ready() -> void:
	$Image.texture = Sprite
	$Name.text = Name
	#Display_Difficulty(modes.SURVIVAL)
			
func Display_Difficulty(mode: modes):
	var diff: difficulties
	$Check.visible = false
	match mode:
		modes.SURVIVAL:
			diff = Difficulty[0]
			if Main.save["Levels"][Name]["Survival"]:
				$Check.visible = true
		modes.CHASE:
			diff = Difficulty[1]
			if Main.save["Levels"][Name]["Chase"]:
				$Check.visible = true
		modes.PLAYGROUND:
			diff = Difficulty[2]
		modes.COLLECT:
			diff = Difficulty[3]
			if Main.save["Levels"][Name]["Collect"]:
				$Check.visible = true
			
	match diff:
		difficulties.BEGINNER:
			$Difficulty.modulate = Colors[0]
			current_diff = "Beginner"
		difficulties.EASY:
			$Difficulty.modulate = Colors[1]
			current_diff = "Easy"
		difficulties.MEDIUM:
			$Difficulty.modulate = Colors[2]
			current_diff = "Medium"
		difficulties.HARD:
			$Difficulty.modulate = Colors[3]
			current_diff = "Hard"
		difficulties.EXTREME:
			$Difficulty.modulate = Colors[4]
			current_diff = "Extreme"
		difficulties.IMPOSSIBLE:
			$Difficulty.modulate = Colors[5]
			current_diff = "Impossible"


func Pressed() -> void:
	$"../../../../..".Select_Level(self)
