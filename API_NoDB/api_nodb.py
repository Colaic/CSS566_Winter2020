# A Basic API for the gatcha game using flask.
# Author: Ardalan Ahanchi

#Filter out the warnings from the terminal output.
import warnings
warnings.filterwarnings("ignore")

import sys
import flask
from flask import request, jsonify
from flask_cors import CORS

#Setup flask.
app = flask.Flask(__name__)
CORS(app)

# Configuration ##########################################################################

#Port for the server.
PORT = 8888

#Minimum username, and password length.
USER_LENGTH = 4
PASS_LENGTH = 6

# Game Data ##############################################################################

#A dictionary that holds the signed up usernames and passwords.
users = {}

##########################################################################################

#A function which authenticates a user based on username and password.
def auth(username, password):
    #Check if the user doesn't exist in the list of users.
    if username not in users:
        return (False, "Not Signed Up.")

    #Check if the password is incorrect.
    if users[username] is not password:
        return (False, "Invalid Password.")

    #If we get here, authentication was successful.
    return (True, "Authentication Successful.")

#Called when a 404 error occures.
@app.errorhandler(404)
def page_not_found(e):
    return jsonify({"status" : "End-point not found."}), 404

#Called when the user requested an authentication.
@app.route('/db/user_auth', methods=['POST'])
def user_auth():
    #Get the JSON data for parsing.
    data = request.get_json()

    try:
        #Recieve the json object.
        username = data["name"]
        password = data["password"]

        #Try to authenticate based on username and password.
        authenticated, auth_msg = auth(username, password)

        #If the user was not authenticated, return a 400 with the message.
        if not authenticated:
            print("Server: Log: Authentication failed for user " + username + ".")
            return jsonify({"status" : auth_msg}), 400
        
        #If we get here authentication was succesful.
        print("Server: Log: Authentication successful for user " + username + ".")
        return jsonify({"status" : "Authentication Successful."}), 200
    except:
		#If invalid object, just return a 400 bad error.
        print("Error: Invalid Json Object.")
        return jsonify({"status" : "Invalid Json Object."}), 400

    #If we get here there was an error.
    print("Server: Log: Authentication Failed")
    return jsonify({"status" : "Authentication Failed."}), 400


#Called when the user requested an authentication.
@app.route('/db/user_create', methods=['POST'])
def user_create():
    #Get the JSON data for parsing.
    data = request.get_json()

    try:
        #Recieve the json object.
        username = data["name"]
        password = data["password"]

        #Check if username is too short.
        if len(username) < USER_LENGTH:
            return jsonify({"status" : "Username should be at least " + str(USER_LENGTH) + " characters."}), 400

        #Check if password is too short.
        if len(password) < PASS_LENGTH:
            return jsonify({"status" : "Password should be at least " + str(PASS_LENGTH) + " characters."}), 400

        #Check if it's a duplicate username:
        if username in users:
            return jsonify({"status" : "Duplicate Username."}), 400

        #If we get here, the username and password are valid, and the user is signed up.
        users[username] = password
        print("Server: Log: Signed up user " + username)
        return jsonify({"status" : "Signup Successful."}), 200
    except:
		#If invalid object, just return a 400 bad error.
        print("Error: Invalid Json Object.")
        return jsonify({"status" : "Invalid Json Object."}), 400

    #If we get here there was an error.
    print("Server: Log: Signup Failed")
    return jsonify({"status" : "Signup Failed."}), 400


if __name__ == "__main__":
	app.run(port=PORT)
