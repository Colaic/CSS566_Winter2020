extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# get_node("Start").connect("pressed", self, "_on_Start_pressed")


func _on_Start_pressed():
	# Going to the next scene, res://WelcomeScene.tscn
	get_tree().change_scene("res://WelcomeScene.tscn")


func _on_Exit_pressed():
	get_tree().quit()
