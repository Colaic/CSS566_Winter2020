extends Node

var _user_signed_up = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#A function which sets the status label to the given string.
func set_status(stat):
	var statusLabel = get_node("/root/Gotcha2D/WelcomeScene/Status")
	statusLabel.text = stat

#A function which retrieves the current username.
func get_username():
	var userTextEdit = get_node("/root/Gotcha2D/WelcomeScene/UsernameTextBox")
	return userTextEdit.get_text()
	
#A function which retrieves the current password.
func get_password():
	var passTextEdit = get_node("/root/Gotcha2D/WelcomeScene/PasswordTextBox")
	return passTextEdit.get_text()


#A function which runs when the signup button is pressed.
func _on_SignupButton_button_up():
	#Get the object for the API.
	var server = get_node("/root/Api")
	
	#Call signup from the API.
	var results = server.signup(get_username(), get_password())
	
	#Check if it was successful, and then update the label.
	if(results["success"]):
		#Change the scene if successful.
		set_status("Signup Successful. Please Login.")
		_user_signed_up = true;
	else:
		set_status("Signup Failed. " + results["msg"])
	
	
#A function which runs when the login button is pressed.
func _on_LoginButton_button_up():	
	#Get the object for the API.
	var server = get_node("/root/Api")
	
	#Call login from the API, and check if it was successful.
	var results = server.login(get_username(), get_password())
	
	#Check if it was successful, and then change the scene.
	if(results["success"]):		
		#If the uesr signed up, take them to user profile. Otherwise to homepage.
		if(server._user_signed_up):
			#Uncommented since it's not working as intended yet.
			#get_tree().change_scene("res://UserProfile.tscn")
			server.set_currency(1000);
			server.set_mission_num(1)
			get_tree().change_scene("res://Homepage.tscn")	
		else:
			get_tree().change_scene("res://Homepage.tscn")
	else:
		set_status("Login Failed. " + results["msg"])
	
#A function which runs when the exit button is pressed.
func _on_Exit_button_up():
	get_tree().quit()
