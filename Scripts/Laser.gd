extends Node2D


@export var On: bool = false
@export var Min: int = 6
@export var Max: int = 25
@onready var time: float = randf_range(Min, Max)
var timer: float = 0
@onready var Point: Vector2 = $Line_1.points[1]
var current_point: Vector2 = Vector2.ZERO



func _ready() -> void:
	$Red.position = Vector2.ZERO
	$Red2.position = Point
	Calculate_Polygon()
	if On:
		Turn_On()


func _process(delta: float) -> void:
	timer += delta
	
	if timer > time:
		timer = 0
		time = randf_range(7, 23)
		if On:
			Turn_Off()
		else:
			$On_Timer.start()
			$Red.emitting = true
			$Red2.emitting = true
			$Line_1.visible = false
			$Line_2.visible = false
			$Line_3.visible = false
			visible = true
			
	$Line_1.points[1] = current_point
	$Line_2.points[1] = current_point
	$Line_3.points[1] = current_point
	
	if $On_Timer_2.time_left > 0:
		Calculate_Polygon()

func Turn_On():
	On = true
	$Line_1.points[1] = Vector2.ZERO
	$Line_2.points[1] = Vector2.ZERO
	$Line_3.points[1] = Vector2.ZERO
	$Line_1.visible = true
	$Line_2.visible = true
	$Line_3.visible = true
	var tween: Tween = create_tween()
	current_point = Vector2.ZERO
	tween.tween_property(self, "current_point", Point, 3.5)
	$Area2D.monitoring = true
	$On_Timer_2.start()
	$Buzz.playing = true
	

func Turn_Off():
	On = false
	$Red.emitting = false
	$Red2.emitting = false
	$Anim.play("Turn_Off")
	$Buzz.playing = false
	
	
func Calculate_Polygon():
	var points = $Line_1.points
	var direction = (points[1] - points[0]).normalized()
	var num = $Line_1.width / 2
	$Area2D/Polygon.polygon = [points[1] + direction * num, points[1] + direction.rotated(PI/2) * num,  points[0] + direction.rotated(PI/2) * num, points[0] - direction * num, points[0] - direction.rotated(PI/2) * num, points[1] - direction.rotated(PI/2) * num]


func Timeout() -> void:
	Calculate_Polygon()


func On_Timer_Timeout() -> void:
	Turn_On()
