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
	# TODO: Remove the api creation here, add code to get user and pass.
	var connector = Api.new("testuser", "testpass")
	connector.sign_up()
	
	get_tree().change_scene("res://UserProfile.tscn")
	pass
