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


func _on_PlayerProfielButton_pressed():
	get_tree().change_scene("res://UserProfile.tscn")
	pass # Replace with function body.


func _on_buttonStore_pressed():
	get_tree().change_scene("res://Store.tscn")


func _on_buttonMissions_button_down():
	get_tree().change_scene("res://Missions.tscn")
	pass # Replace with function body.
