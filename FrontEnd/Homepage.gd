extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var server = get_node("/root/Api")

# Called when the node enters the scene tree for the first time.
func _ready():
	var UserLabel = get_node("HomePage/UsernameField")
	UserLabel.text = str(server._user)
	
	var MissionLabel = get_node("HomePage/MissionField")
	MissionLabel.text = str(server.get_mission_num())
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
