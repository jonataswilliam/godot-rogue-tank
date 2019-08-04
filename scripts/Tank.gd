tool
extends KinematicBody2D

# PI = 180 graus
const ROT_VEL = PI / 2
const MAX_SPEED = 200

var dead_zone  = 0.02
var acell = 0
var travel = 0
var move = 0
var pre_bullet = preload("res://scenes/Bullet.tscn")
var pre_track = preload("res://scenes/Track.tscn")
var pre_mg_bullet = preload("res://scenes/mg_bullet.tscn")
var can_mouse_look = false
var loaded = true
var mg_loaded = true

export(int, "bigRed", "blue", "dark", "darkLarge", "darkLarge_outline", "dark_outline", "green", "huge", "sand") var indexBody = 0 setget set_bodie

var BULLET_TANK_GROUP = "bullet-" + str(self)

var bodies = [
	"res://sprites/tankBody_bigRed.png",
	"res://sprites/tankBody_blue.png",
	"res://sprites/tankBody_dark.png",
	"res://sprites/tankBody_darkLarge.png",
	"res://sprites/tankBody_darkLarge_outline.png",
	"res://sprites/tankBody_dark_outline.png",
	"res://sprites/tankBody_green.png",
	"res://sprites/tankBody_huge.png",	
	"res://sprites/tankBody_sand.png"
]

# Called when the node enters the scene tree for the first time.
func _ready():		
	pass

func _draw():
	$sprite.texture = load(bodies[indexBody])
	
func _input(event):
	if event is InputEventMouseMotion:
		can_mouse_look = true	

func _physics_process(delta):
	if Engine.editor_hint:
		return 
#

	# Shoot Controls
	if Input.is_action_just_pressed("ui_shoot") && loaded:
#		if get_tree().get_nodes_in_group(BULLET_TANK_GROUP).size() < 8:			
		shoot()		
	
	if Input.is_action_pressed("ui_machine_gun") && mg_loaded:		
		mg_shoot()
		$machineGun/shoot_interval.start()		
		
	# Barrel Controls	
	var rot_hor_axis = Input.get_joy_axis(0, JOY_AXIS_2)
	var rot_ver_axis = Input.get_joy_axis(0, JOY_AXIS_3)
	
	if abs(rot_hor_axis) < dead_zone:
		rot_hor_axis = 0
		
	if abs(rot_ver_axis) < dead_zone:
		rot_ver_axis = 0	
	
	if rot_hor_axis != 0 && rot_ver_axis != 0:
		
		var vector = Vector2(rot_hor_axis, rot_ver_axis)
		
		if vector.length() > .8:
			can_mouse_look = false
			$barrel.global_rotation = Vector2(rot_hor_axis, rot_ver_axis).normalized().angle()
		
	if can_mouse_look:
		$barrel.look_at(get_global_mouse_position())
		
	
	var vel_mod = 1
	if get_tree().get_nodes_in_group(str(self) + "-oil").size() > 0:
		vel_mod = .3
		
	# Tank Controls
	var rot = 0
	var dir = 0	
	
	if Input.is_action_pressed("ui_right"):		
		rot += 1

	if Input.is_action_pressed("ui_left"):		
		rot -= 1
	
	if rot == 0:
		rot = Input.get_joy_axis(0, JOY_AXIS_0)
		
		
	if Input.is_action_pressed("ui_down"):
		dir -= 1

	if Input.is_action_pressed("ui_up"):
		dir += 1
		
	if dir == 0:
		dir = -Input.get_joy_axis(0, JOY_AXIS_1)			
	
	rotate(ROT_VEL * rot * delta)		

	acell = lerp(acell, MAX_SPEED * dir, .03)	
	
	move = move_and_slide(Vector2(cos(rotation), sin(rotation)) * acell * vel_mod)	
	travel += move.length() * delta		
	
	if travel > $sprite.texture.get_size().y:
		print(travel)
		var track = pre_track.instance()
		track.global_position = global_position - Vector2(cos(rotation), sin(rotation)).normalized() * 5
		track.rotate(global_rotation)
		track.z_index = z_index -1
		$"../".add_child(track)
		travel = 0
		

func shoot():
	# Bullet Instance
	var bullet = pre_bullet.instance()	
	
	#Bullet Direction
	bullet.global_position = $barrel/muzzle.global_position
	bullet.dir = Vector2(cos($barrel.global_rotation), sin($barrel.global_rotation)).normalized()
	
	$"../".add_child(bullet) # add tiro na cena
	# get_parent().add_child(bullet) # equivalente ao comando de cima		
	bullet.add_to_group(BULLET_TANK_GROUP)
			
	#Shoot Distance 
	bullet.dist_max = $barrel/sight.position.x - $barrel/muzzle.position.x - 9
	
	# Reload
	loaded = false
	$barrel/sight.update()
	
	# Animations
	$barrel/anim.play("fire")
	$barrel/anim_barrel.play("shoot")
	
func mg_shoot():
	# Instance
	var mg_bullet = pre_mg_bullet.instance()
	
	# Direction
	mg_bullet.global_position = $machineGun/mg_muzzle.global_position
	mg_bullet.global_rotation = global_rotation
	mg_bullet.dir = Vector2(cos(global_rotation), sin(global_rotation))
	
	get_parent().add_child(mg_bullet)
	
	mg_loaded = false	
		
func set_bodie(val):
	indexBody = val
	if Engine.editor_hint:
		update()
		
func _on_loadTimer_timeout():	
	loaded = true
	$barrel/sight.update()	


func _on_shoot_interval_timeout():
	mg_shoot()
	print("A")
	mg_loaded = true
	
	
	pass # Replace with function body.
