extends Node

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
	
	#Call signup from the API, and check if it was successufl.
	if(server.signup(get_username(), get_password())):
		#Change the scene if successful.
		get_tree().change_scene("res://LoadingScreen.tscn")
	else:
		set_status("Signup Failed")
	
	
#A function which runs when the login button is pressed.
func _on_LoginButton_button_up():	
	
	#Get the object for the API.
	var server = get_node("/root/Api")
	
	#Call signup from the API, and check if it was successufl.
	if(server.login(get_username(), get_password())):
		#Change the scene if successful.
		get_tree().change_scene("res://LoadingScreen.tscn")
	else:
		set_status("Login Failed")
	
	
#A function which runs when the exit button is pressed.
func _on_Exit_button_up():
	get_tree().quit()
