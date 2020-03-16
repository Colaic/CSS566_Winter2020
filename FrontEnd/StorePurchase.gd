extends Control


# Declare member variables here. Examples:
var userCurrency = 5000


# Called when the node enters the scene tree for the first time.
func _ready():
	#get_node("SummonPanel").visible = not visible
	pass # Replace with function body.



func _on_SummonButton_button_up():
	get_node("SummonPanel").popup()

func _on_CloseWindow_pressed():
	get_node("SummonPanel").hide()

