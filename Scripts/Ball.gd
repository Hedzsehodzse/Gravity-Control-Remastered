extends RigidBody2D

@export var gravity_strength: float = 400
@export var Reload_Time: float = 10
enum weapons {LASER, ROCKET}
@export var Weapon: weapons

var gravity_dir: Vector2 = Vector2.DOWN
@onready var Main: Node2D = get_parent()
var Reload_Timer: float = 0
var first_time: bool = true

@onready var Reload: Node = $"../UI/Reload"

var mouse_control: bool = false


func _ready() -> void:
	if Weapon == weapons.ROCKET:
		$Shoot.volume_db = -2
		$Shoot.stream = load("res://Sounds/Rocket.mp3")
		Reload_Time = 15
	if Weapon == weapons.LASER:
		$Shoot.volume_db = -11
		$Shoot.stream = load("res://Sounds/Laser.mp3")
		Reload_Time = 10
		
	if $"..".Game_Mode == $"..".modes.PLAYGROUND:
		Reload_Time = 1
		


func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	var gravity: Vector2
	
#---------------------MOVEMENT---------------------#
	if mouse_control:
		gravity = (mouse_pos - global_position).normalized() * gravity_strength
	else:
		if Input.is_action_pressed("W"):
			gravity_dir = Vector2.UP
		if Input.is_action_pressed("S"):
			gravity_dir = Vector2.DOWN
		if Input.is_action_pressed("A"):
			gravity_dir = Vector2.LEFT
		if Input.is_action_pressed("D"):
			gravity_dir = Vector2.RIGHT
		gravity = gravity_dir * gravity_strength
	Main.gravity = gravity
	
	linear_velocity += gravity * delta
	
	
#---------------------SHOOT---------------------#	
	Reload_Timer += delta
	
		
	
	if Reload_Timer > Reload_Time and ($"..".Game_Mode == $"..".modes.CHASE or $"..".Game_Mode == $"..".modes.PLAYGROUND):
		Reload.value = 100
		Reload.modulate.a = 1.0
		if first_time:
			$"..".Play_Sound(load("res://Sounds/Reload.mp3"), -5, global_position)
			first_time = false
	else:
		Reload.value = (Reload_Timer / Reload_Time) * 100
		Reload.modulate.a = 0.5
		
	if Input.is_action_pressed("Left_Click") and Reload_Timer > Reload_Time and ($"..".Game_Mode == $"..".modes.CHASE or $"..".Game_Mode == $"..".modes.PLAYGROUND):
		Reload_Timer = 0
		$Shoot.play()
		first_time = true
		
		if Weapon == weapons.LASER:
			var laser = load("res://Scenes/Projectiles/Laser.tscn").instantiate()
			add_child(laser)
			laser.global_position = global_position
			laser.look_at(mouse_pos)
			laser.global_rotation -= PI/2
			
			var ray = laser.get_node("Ray")
			var anim = laser.get_node("Anim")
			var point = mouse_pos
		
			ray.force_raycast_update()
			if ray.is_colliding():
				point = ray.get_collision_point()
				var collider = ray.get_collider()
				if collider.is_in_group("Enemy"):
					collider.Die()
			var array = [Vector2(0,0), ray.to_local(point)]
			for i in range(3):
				var line = laser.get_node("Line_" + str(i + 1))
				line.points = array
			anim.play("Anim")
		else:
			var rocket = load("res://Scenes/Projectiles/Rocket.tscn").instantiate()
			add_sibling(rocket)
			rocket.global_position = global_position + (get_global_mouse_position() - global_position).normalized() * 20
			rocket.velocity = linear_velocity / 4 + (get_global_mouse_position() - global_position).normalized() * 300
		


func Body_Entered(body: Node) -> void:
	if !body.is_in_group("Enemy") and !body.is_in_group("Player") and linear_velocity.length() > 70:
		var particle = load("res://Scenes/Particles/Hit_Particle.tscn").instantiate()
		Main.add_child(particle)
		particle.Main = Main
		particle.global_position = global_position
		particle.global_rotation = global_rotation
		for node in body.get_children():
			if node is Polygon2D:
				particle.modulate = node.color
				break
			if node is Sprite2D:
				particle.modulate = node.modulate
				break
		particle.amount = round(linear_velocity.length()/100)
		particle.set_process(true)
		particle.emitting = true
