extends Area2D

var dist_max = 150
var velocity = 400
var dir = Vector2()

onready var initPos = self.global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	translate(dir * delta * velocity)
	if global_position.distance_to(initPos) > dist_max:
		queue_free()


func _on_mg_bullet_body_entered(body):
	queue_free()
	pass # Replace with function body.
