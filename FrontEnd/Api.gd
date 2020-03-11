extends Node

# Class variables
var _http = null
var _user = null
var _pass = null
#const _URL = "18.191.61.189"
const _URL = "0.0.0.0"
const _PORT = 8888

# Called when the node enters the scene tree for the first time.
func _init():
	print("Connecting to the server...")
	
	_http = HTTPClient.new()
	_http.connect_to_host(_URL, _PORT, false, true)
	
	# Wait until resolved and connected.
	while _http.get_status() == HTTPClient.STATUS_CONNECTING or _http.get_status() == HTTPClient.STATUS_RESOLVING:
		_http.poll()
		OS.delay_msec(500)
		
#A method which authenticates the user.
func login(username, password):
	#Set the username and password.
	_user = username
	_pass = password
	
	#Print out the login message for logging purposes.
	print("Logging in user " + _user + "...")
	
	#Create the request with the given parameters, and make the post request.
	var data = {"name" : _user, "password" : _pass}
	var post_response = _post(data, "/db/user_auth")
	
	#Parse the JSON message, and check the response code.
	var msg = _get_response_msg(post_response)
	if(post_response["code"] != 200):
		return {"success" : false , "message" : msg}
	
	#If we get here, it was successful.
	return {"success" : true, "message" : msg}

# A method for signing up the user
func signup(username, password):
	#Set the username and password.
	_user = username
	_pass = password
	
	#Print out the signup message for logging purposes.
	print("Signing up user " + _user + "...")
	
	#Create the request with the given parameters, and make the post request.
	var data = {"name" : _user, "password" : _pass}
	var post_response = _post(data, "/db/user_create")
	
	#Parse the JSON message, and check the response code.
	var msg = _get_response_msg(post_response)
	if(post_response["code"] != 200):
		return {"success" : false , "message" : msg}
	
	#If we get here, it was successful.
	return {"success" : true, "message" : msg}

#A function which returns the message with key "status" from the server.
func _get_response_msg(post_response):
	return JSON.parse(post_response["json"]).result["status"]

# A method which makes post requests to the server, and sends JSON over.
func _post(data, url):
	#If we got disconnected, reconnect.
	if(_http.get_status() != HTTPClient.STATUS_CONNECTED):
		_init()
		
	#Create a query, and then create a post request to the server.
	var query = JSON.print(data)
	var headers = ["Content-Type: application/json", "user-agent: GotchaGame"]
	var results = _http.request(_http.METHOD_POST, url, headers, query)
	
	#Check the return value.
	if(results != OK):
		return {"code" : 400, "json" : JSON.print({"status" : "Request Failed."})}

	#Wait till the request is completed.
	while (_http.get_status() == HTTPClient.STATUS_REQUESTING):
		_http.poll()
		OS.delay_msec(500)
	
	#If we get disconnected return an error.
	if(_http.get_status() != HTTPClient.STATUS_BODY and 
	_http.get_status() != HTTPClient.STATUS_CONNECTED):
		return {"code" : 400, "json" : JSON.print({"status" : "Connection Failed."})}
	
	#If we didn't get a response, return error.
	if (!_http.has_response()):
		return {"code" : 400, "json" : JSON.print({"status" : "No Response From Server."})}
	
	#If we didn't get a 200 status, return the error.
	#if (_http.get_response_code() != 200):
	#	return {"code" : _http.get_response_code(), "json" : JSON.print({"status" : "Request Failed."})}
		
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
	return {"code" : _http.get_response_code(), "json" : res_data_text}
