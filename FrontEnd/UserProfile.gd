extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	#Get the object for the API.
	var server = get_node("/root/Api")
	
	#Get the object for labels.
	var username = get_node("UserProfileInfo/Username")
	var mission = get_node("UserProfileInfo/Mission")
	var currency = get_node("UserProfileInfo/Currency")
	var num_chars = get_node("UserProfileInfo/NumChars")
	var num_items = get_node("UserProfileInfo/NumItems")
	
	#Set the labels accordingly.
	username.text = server._user
	mission.text = str(server.get_mission_num())
	currency.text = str(server.get_currency())
	num_chars.text = str(len(server.get_characters()))
	num_items.text = str(len(server.get_items()))
