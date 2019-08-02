extends Area2D

var dir = Vector2(0, -1) setget set_dir
var velocity = 250

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(dir * velocity * delta)

func _on_notifier_screen_exited():	
	queue_free() # Coloca na fila para limpar a memoria destruindo este item	

func set_dir(val):
	dir = val
	rotation = dir.angle()