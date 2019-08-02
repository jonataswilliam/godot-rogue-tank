extends KinematicBody2D

var speed = 100
var pre_bullet = preload("res://scenes/Bullet.tscn")
var indexBody = 0

var bodies = [
	"res://sprites/tankBody_bigRed.png",
	"res://sprites/tankBody_blue.png",
	"res://sprites/tankBody_dark.png",
	"res://sprites/tankBody_darkLarge.png",
	"res://sprites/tankBody_darkLarge_outline.png",
	"res://sprites/tankBody_dark_outline.png",
	"res://sprites/tankBody_green.png",
	"res://sprites/tankBody_huge.png",
	"res://sprites/tankBody_huge_outline.png",
	"res://sprites/tankBody_sand.png"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$sprite.texture = load(bodies[7])
	pass


func _process(delta):
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
		if indexBody >= bodies.size(): indexBody = 0
		$sprite.texture = load(bodies[indexBody])
		
	if Input.is_action_just_pressed("ui_change_body_down"):		
		indexBody -= 1
		if indexBody < 0: indexBody = bodies.size()-1
		
		$sprite.texture = load(bodies[indexBody])
		
	if Input.is_action_just_pressed("ui_shoot"):
		if get_tree().get_nodes_in_group("cannon_bullets").size() < 8:
			var bullet = pre_bullet.instance()
			bullet.global_position = $barrel/muzzle.global_position
			$"../".add_child(bullet) # add tiro na cena
			# get_parent().add_child(bullet) # equivalente ao comando de cima	
			bullet.dir = Vector2(cos(rotation), sin(rotation)).normalized()
			$barrel/anim.play("fire")
		
	translate(Vector2(dir_x, dir_y) * delta * speed)
	
	look_at(get_global_mouse_position())
	
