extends Node

class_name Api

# Class variables
var _http = null
var _user = null
var _pass = null
const _URL = "http://18.191.61.189/"
const _PORT = 8888

# Default constructor, which initializes the API with the username and pass.
func _init(username, password):
	_user = username
	_pass = password
	_http = HTTPClient.new()
	_http.connect_to_host(_URL, _PORT, false, true)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# A method for signing up the user
func sign_up():
	var fields = {"name" : _user, "password" : _pass}
	var query = _http.query_string_from_dict(fields)
	var headers = ["Content-Type: application/json", "user-agent: GotchaGame", "Content-Length: " + str(query.length())]
	var results = _http.request(_http.METHOD_POST, "db/user_create", headers, query)
	
	#TODO: Check the results, remove the print
	print(results)
