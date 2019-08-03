tool
extends KinematicBody2D

var speed = 200
var pre_bullet = preload("res://scenes/Bullet.tscn")
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

func _process(delta):
	if Engine.editor_hint:
		return 
		
	var dir_x = 0
	var dir_y = 0
	
	if Input.is_action_pressed("ui_right"):		
		dir_x += 1
	
	if Input.is_action_pressed("ui_left"):		
		dir_x -= 1
		
	if Input.is_action_pressed("ui_down"):		
		dir_y += 1
	
	if Input.is_action_pressed("ui_up"):		
		dir_y -= 1
		
	if Input.is_action_just_pressed("ui_change_body_up"):
		indexBody += 1
		if indexBody >= bodies.size(): 
			indexBody = 0
		$sprite.texture = load(bodies[indexBody])
		
	if Input.is_action_just_pressed("ui_change_body_down"):		
		indexBody -= 1
		if indexBody < 0: indexBody = bodies.size()-1
								
	if Input.is_action_just_pressed("ui_shoot"):
		if get_tree().get_nodes_in_group(BULLET_TANK_GROUP).size() < 8:
			var bullet = pre_bullet.instance()
			bullet.global_position = $barrel/muzzle.global_position
			$"../".add_child(bullet) # add tiro na cena
			# get_parent().add_child(bullet) # equivalente ao comando de cima	
			bullet.dir = Vector2(cos(rotation), sin(rotation)).normalized()
			$barrel/anim.play("fire")
			bullet.add_to_group(BULLET_TANK_GROUP)
		
	move_and_slide(Vector2(dir_x, dir_y) * speed)
	
	look_at(get_global_mouse_position())
	
func set_bodie(val):
	indexBody = val
	if Engine.editor_hint:
		update()
	
