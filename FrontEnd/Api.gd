extends Node

# Class variables
var _http = null
var _user = null
var _pass = null
const _URL = "18.191.61.189"
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
		
	#Check if we're connected.
	assert(_http.get_status() == HTTPClient.STATUS_CONNECTED)

# A method for signing up the user
func sign_up(username, password):
	print("Signing up user " + username + "...")
	
	#Set the username and password.
	_user = username
	_pass = password
	
	#Create the request with the given parameters, and make the request.
	var fields = {"name" : _user, "password" : _pass}
	var query = _http.query_string_from_dict(fields)
	var headers = ["Content-Type: application/json", "user-agent: GotchaGame", "Content-Length: " + str(query.length())]
	var results = _http.request(_http.METHOD_POST, "/db/user_create", headers, query)
	
	#Check if the results are OK
	assert(results == OK)
