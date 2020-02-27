extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_LogInButton_button_up():
	# TODO: Add code for logging in instead of signing up.
	var server = get_node("/root/Api")
	server.sign_up("CSTEST1", "CSTEST2")
	
	get_tree().change_scene("res://UserProfile.tscn")
	pass
