extends Node

const CHARACTER_NAMES = ["Silver Knight", "Gold Knight", "Warrior", "Horse", "Yeoman", "Master Cow", "Red Knight", "Orange Knight", "Magician", "Blue Warrior", "Dwarf Warrior", "Elf Warrior", "Elf Captain", "Assassin", "King", "Blue Wizard", "Peasant", "Archer", "Druid", "CASTLE"]

# Called when the node enters the scene tree for the first time.
func _ready():
	#Get the object for the API.
	var server = get_node("/root/Api")
	
	#Get the object for labels.
	var character_nodes = []
	
	#Get all the nodes.
	for i in range(1, 21):
		#Find out the extensions
		var extension = str(i)
		character_nodes.append(get_node("BackgroundPanel/CharacterPanel" + extension))
			
	#Get the current charactesrs, and make appropriate ones visible.
	var characters = server.get_characters()
	
	#Go through the characters and make them visible if needed.
	for character in characters: 
		character_nodes[ int(character["id"]) ].visible = true
