extends Area2D

var dist_max = 300

var dir = Vector2(0, -1) setget set_dir
onready var init_pos = global_position
var velocity = 400
var live = true

func _ready():	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if live:	
		if global_position.distance_to(init_pos) >= dist_max:
			auto_destroy()	
	
		translate(dir * velocity * delta)
	

func _on_notifier_screen_exited():	
	queue_free() # Coloca na fila para limpar a memoria destruindo este item	

func set_dir(val):
	dir = val
	rotation = dir.angle()
	
func auto_destroy():
	$smoke.emitting = false
	$sprite.visible = false
	$anim_auto_destroy.play("destroyed")
	live = false	
	call_deferred("set_monitorable", false)
#	monitorable = false
	call_deferred("set_monitoring", false)
#	monitoring = false
	yield($anim_auto_destroy, "animation_finished")
	queue_free()

func _on_Bullet_body_entered(body):
	if body.collision_layer == 4:
		auto_destroy()
	
