extends Node

#Constants for URL and PORT for accessing the server.
const _URL = "18.191.61.189"
const _PORT = 8888

#Constant addresses for the end points
const _ADDR_TOKEN = "/api/token"
const _ADDR_SIGNUP = "/db/player/create"
const _ADDR_PLAYER = "/db/player"
const _ADDR_CHPASS = "/db/player/change_password"

#Class variables
var _http = null
var _user = null
var _pass = null

#Used to cache user stats.
var _currency = null
var _mission_num = null
var _characters = null
var _user_items = null

#Tokens for accessing the API.
var _refresh_token = null
var _access_token = null

#Checks if user signed up in this session.
var _user_just_signed_up = false

# Called when the node enters the scene tree for the first time.
func _init():
	print("Connecting to the server...")

	#Initialize the required class variable.
	_user_just_signed_up = false
	
	#Initialize a new http client.
	_http = HTTPClient.new()
	
	#Connect to it.
	_http_connect()
	
#A function which attemps to connect to the HTTP connection previously initialized.
func _http_connect():
	#Connect it to the host.
	_http.connect_to_host(_URL, _PORT, false, true)
	
	# Wait until resolved and connected.
	while _http.get_status() == HTTPClient.STATUS_CONNECTING or _http.get_status() == HTTPClient.STATUS_RESOLVING:
		_http.poll()
		OS.delay_msec(500)
		
# Player data access functions #################################################

#A function which retrieves the user's currency.	
func get_currency():
	#The data is already cached, so just return it.
	return _currency
	
#A function which retrieves the user's currency.	
func set_currency(new_value):
	#Create a dictionary with teh new value for the currency.
	var dict = { "currency" : new_value }
	var response = _update_player(dict)
	
	#If retrieval was successful, return the dictionary.
	if(response["success"]):
		_currency = new_value
		return response["dict"]
		
	#If we get here there was an error, so return an empty dictionary.
	print("set_currency: Error: Could not update the user info.")
	return {}
	
#A function which retrieves the user's mission number.	
func get_mission_num():
	#The data is already cached, so just return it.
	return _mission_num
	
#A function which retrieves the user's mission number.	
func set_mission_num(new_value):
	#Create a dictionary with teh new value.
	var dict = { "missionNum" : new_value }
	var response = _update_player(dict)
	
	#If retrieval was successful, return the dictionary.
	if(response["success"]):
		_mission_num = new_value
		return response["dict"]
		
	#If we get here there was an error, so return an empty dictionary.
	print("set_mission_num: Error: Could not update the user info.")
	return {}
	
#A function which retrieves all the user's characters.	
func get_characters():
	#The data is already cached, so just return it.
	return _characters
	
#A function which adds a new character to player's characters.	
func add_character(new_character_id, new_character_name):
	#Add the character to the current list of characters.
	_characters.append({"id" : new_character_id, "name" : new_character_name})
	
	#Create a dictionary with teh new value for the characters.
	var dict = { "characters" : _characters }
	var response = _update_player(dict)
	
	#If retrieval was successful, return the dictionary.
	if(response["success"]):
		return true
		
	#If we get here there was an error, so return an empty dictionary.
	print("add_character: Error: Could not update the user info.")
	return false
	

#A function which retrieves all the user's items.	
func get_items():
	#The data is already cached, so just return it.
	return _user_items
	
#A function which adds a new item to user's items.	
func add_item(new_item_id, new_item_name):
	var item_is_new = true
	
	#Check if the item already exists in the items.
	for item in _user_items:
		#Increase the item number if it already exists.
		if(item["item"]["id"] == new_item_id):
			item_is_new = false
			item["count"] = item["count"] + 1
			
	#If the item did not exist, add it.
	if(item_is_new):
		_user_items.append({"item" : {"id" : new_item_id, "name" : new_item_name}, "count" : 1})
	
	#Create a dictionary with teh new value for the characters.
	var dict = { "userItem" : _user_items }
	var response = _update_player(dict)
	
	#If retrieval was successful, return the dictionary.
	if(response["success"]):
		return true
		
	#If we get here there was an error, so return an empty dictionary.
	print("add_item: Error: Could not update the user info.")
	return false
	
################################################################################
		
#A method which authenticates the user.
func login(username, password):
	#Set the username and password.
	_user = username
	_pass = password
	
	#Print out the login message for logging purposes.
	print("Logging in user " + _user + "...")
	
	#Request tokens from the server based on the username and password.
	var tk_results = _update_tokens()
	
	#If the request was successful, get the player data.
	if(tk_results["success"]):
		_get_player()
	else:
		print("login: Error: Could not get player information.")
	
	return tk_results

# A method for signing up the user
func signup(username, password):
	#Set the username and password.
	_user = username
	_pass = password
	
	#Print out the signup message for logging purposes.
	print("Signing up user " + _user + "...")
	
	#Create the request with the given parameters, and make the post request.
	var data = {"username" : _user, "password" : _pass}
	var post_response = _post(_ADDR_SIGNUP, data)
	
	#Update the just signed up value.
	_user_just_signed_up = true
	
	#Return the results back to the program
	return {"success" : (post_response["code"] == 200), "msg": post_response["data"]}


# A method for changing the password for the given username.
func change_password(username, old_password, new_password):	
	#Create the request with the given parameters, and make the post request.
	var data = {"username" : username, "oldPassword" : old_password, "newPassword" : new_password}
	var response = _post(_ADDR_CHPASS, data)
	
	#If it was successful, set the username and password to the updated values.
	#And then return the success value and message.
	if(response["code"] == 200):
		_user = username
		_pass = new_password
		return {"success" : true, "msg": "Password changed."}
		
	#If we get here, there was an error, then print the error message.
	return {"success" : false, "msg": response["data"]}
	

#A method for updating the player information.
#Data is a dictionary of values for the keys that have to be updated.
func _update_player(data):
	#Update the player information based on the passed data.
	var response = _patch(_ADDR_PLAYER + "/" + _user + "/change", data)
	
	#If the token experied, update token and try again.
	if(response["code"] == 401):
		_update_tokens()
		response = _patch(_ADDR_PLAYER + "/" + _user + "/change", data)
		
	#If it was successful, parse the data and return the dictionary.
	if(response["code"] == 200):
		return {"success" : true, "dict": JSON.parse(response["data"]).result}

	#If it was not successful, return an empty dictionary (and print data).
	print("_update_player: Error: Did not get OK from the server.")
	print(response["data"])
	return {"success" : false, "dict": response["data"]}
	
	
#A method for getting all the player information.
func _get_player():
	#Get the player information from the server.
	var response = _get(_ADDR_PLAYER)
	
	#If the token experied, update token and try again.
	if(response["code"] == 401):
		_update_tokens()
		response = _get(_ADDR_PLAYER)
		
	#If it was successful, parse the data and update the cache.
	if(response["code"] == 200):
		_currency = JSON.parse(response["data"]).result[0]["currency"]
		_mission_num = JSON.parse(response["data"]).result[0]["missionNum"]
		_characters = JSON.parse(response["data"]).result[0]["characters"]
		_user_items = JSON.parse(response["data"]).result[0]["userItem"]
		return true

	#If it was not successful, return an empty dictionary (and print data).
	print("_get_player: Error: Did not get OK from the server.")
	print(response["data"])
	return false


# A method which requests new tokens from the server, and updates the class variables.
func _update_tokens():
	#Get the new tokens from the server by providing username and password.
	var response = _post(_ADDR_TOKEN, {"username" : _user, "password" : _pass})

	#If tokens were successfully returned, update the class variables.
	if(response["code"] == 200):
		_refresh_token = JSON.parse(response["data"]).result["refresh"]
		_access_token = JSON.parse(response["data"]).result["access"]
		return {"success" : true, "msg": ""}
	
	#If we are unauthorized, return the proper error message.
	if(response["code"] == 401):
		return {"success" : false, "msg": JSON.parse(response["data"]).result["detail"]}
		
	#If we get here, there was an unknwon error in updating the tokens.
	print("_update_tokens: Error: Did not get OK from the server.")
	print(response["data"])
	return {"success" : false, "msg": "Error in request."}


# A wrapper function for the req method to provide a HTTP POST request. It parses the JSON
# data into the query, and makes a request to the server.
func _post(url, data):
	var query = JSON.print(data)
	return _req(_http.METHOD_POST, url, query)

# A wrapper function for the req method to provide a HTTP GET request.
func _get(url):
	return _req(_http.METHOD_GET, url, "")
	
# A wrapper functin which provides PATCH HTTP requests.
func _patch(url, data):
	var query = JSON.print(data)
	return _req(_http.METHOD_PATCH, url, query)

# A method which makes post requests to the server, and sends JSON over, it then returns
# The response code along with the sent back data.
func _req(method, url, query):
	#If we got disconnected, reconnect.
	if(_http.get_status() != HTTPClient.STATUS_CONNECTED):
		_http_connect()
		
	#Define the headers, and add the authorization header.
	var headers = ["Content-Type: application/json", "User-Agent: GotchaGame"]

	#Create the authorization header, and append it to headers if it was used..
	if(_access_token):
		headers.append("Authorization: Bearer " + _access_token)
		
	#Create the request, and capture response.
	var results = _http.request(method, url, headers, query)
	
	#Check the return value.
	if(results != OK):
		return {"code" : 400, "data" : JSON.print({"detail" : "Request Failed."})}

	#Wait till the request is completed.
	while (_http.get_status() == HTTPClient.STATUS_REQUESTING):
		_http.poll()
		OS.delay_msec(500)
	
	#If we get disconnected return an error.
	if(_http.get_status() != HTTPClient.STATUS_BODY and 
	_http.get_status() != HTTPClient.STATUS_CONNECTED):
		return {"code" : 400, "data" : JSON.print({"detail" : "Connection Failed."})}
	
	#If we didn't get a response, return error.
	if (!_http.has_response()):
		return {"code" : _http.get_response_code(), "data" : JSON.print({"detail" : "No Response From Server."})}
		
	#If everything went fine, poll and recieve all the data from server.
	var res_data = PoolByteArray()
	while (_http.get_status() == HTTPClient.STATUS_BODY):
		_http.poll()
		var chunk = _http.read_response_body_chunk()
		if chunk.size() == 0:
			OS.delay_usec(500)
		else:
			res_data = res_data + chunk
	
	#Convert the data to text, and return it with the response code.
	var res_data_text = res_data.get_string_from_utf8()
	return {"code" : _http.get_response_code(), "data" : res_data_text}
