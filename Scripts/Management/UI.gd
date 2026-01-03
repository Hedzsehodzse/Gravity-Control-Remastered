extends CanvasLayer


@onready var Main: Node = %Ball.get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Main.Game_Mode == Main.modes.CHASE or Main.Game_Mode == Main.modes.PLAYGROUND:
		$Selection/Anim.play("Fade")
	else:
		get_tree().paused = false
		

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
