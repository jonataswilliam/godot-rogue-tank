extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_oil_body_entered(body):
	#Add o oleo para um grupo com o nome do tank-oil
	add_to_group(str(body) + "-oil")
	


func _on_oil_body_exited(body):
	#Remove o oleo de um grupo com o nome do tank-oil
	remove_from_group(str(body) + "-oil")
	
