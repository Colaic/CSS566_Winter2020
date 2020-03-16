extends Control

const SUMMON_COST = 1000
onready var server = get_node("/root/Api")
var userCurrency
var summonSprite
var summonSpriteName
var summonSpriteLevel
var rng = RandomNumberGenerator.new()

# enter store scene with updated userCurrency
func _ready():
	randomize() # somehow this is doesn't work as the seed is always the same...
	
	userCurrency =  server.get_currency() # needs to be API GET call to DB
	print(userCurrency)
	get_node("CurrencyWidget/RichTextLabel").text = str(userCurrency)

# Character summon button, can only summon if user has currency > SUMMON_COST
func _on_SummonButton_button_up():
	if (userCurrency >= SUMMON_COST):
		# random level, random character
		summon(rng.randi_range(1, 100), rng.randi_range(1,10))
		get_node("SummonPopup").popup()
		subtractCurrency(SUMMON_COST)
	
func _on_CloseWindow_pressed():
	get_node("SummonPopup").hide()

# Summon panel sprite size
func _on_Sprite_draw():
	var pos = Vector2(243, 263) # currently hardcoded positions from visual test
	var scale = Vector2(1, 1)
	summonSprite.set_scale(scale)
	draw_texture(summonSprite, pos)

# populates sprite texture, level, and name (currently only loads the first 10)
# images are retrieved from res://Characters/PlayerCharacters/* and must be named
# in the format of c<character id>_<character name>.png
func summon(rngLevel, rngCharacter):
	var characterWordCount
	var spaceSplitArray
	var characterImgName = ""  #character name field in image name
	
	summonSprite = get_node("SummonPopup/SummonPanel/Sprite")
	
	# 80% chance of level 1
	if (rngLevel >= 20):
		summonSpriteLevel = 1
	# 10% chance of level 2
	elif (rngLevel >= 10 && rngLevel < 20):
		summonSpriteLevel = 2
	# 5% chance of level 3
	elif (rngLevel >= 5 && rngLevel < 10):
		summonSpriteLevel = 3
	# 3% chance of level 4
	elif (rngLevel >= 3 && rngLevel < 5):
		summonSpriteLevel = 4
	# 2% chance of level 5
	else: 
		summonSpriteLevel = 5
	
	# equal chance of obtaining any one of the 10 characters
	if (rngCharacter == 1):
		summonSpriteName = "Green Warrior"	
	elif (rngCharacter == 2):
		summonSpriteName = "Blue Assassin"	
	elif (rngCharacter == 3):
		summonSpriteName = "Green Archer"	
	elif (rngCharacter == 4):
		summonSpriteName = "Druid"
	elif (rngCharacter == 5):
		summonSpriteName = "Magician"	
	elif (rngCharacter == 6):
		summonSpriteName = "Ant"	
	elif (rngCharacter == 7):
		summonSpriteName = "Unicorn"	
	elif (rngCharacter == 8):
		summonSpriteName = "Silver Knight"	
	elif (rngCharacter == 9):
		summonSpriteName = "Golden Knight"	
	elif (rngCharacter == 10):
		summonSpriteName = "King Knight"
	
	spaceSplitArray = summonSpriteName.split(' ', false);
	characterWordCount = spaceSplitArray.size()
		
	for i in range (0, characterWordCount):
		characterImgName = str(characterImgName + spaceSplitArray[i])
	
	get_node("SummonPopup/SummonPanel/CharacterLevel").text = "Level " + str(summonSpriteLevel)	
	get_node("SummonPopup/SummonPanel/CharacterName").text = str(summonSpriteName)
	summonSprite.texture = load("res://Image/Characters/PlayerCharacters/c" + 
							str(rngCharacter) + "_" + characterImgName + ".png")

	# TODO: call API to update user character's list
	
	
# subtracts user currency given cost
func subtractCurrency(cost):
	if (userCurrency <= 0):
		print("User has no more currency available.")
	else:
		userCurrency -= cost # needs to be API POST call to DB
		server.set_currency(userCurrency)
		get_node("CurrencyWidget/RichTextLabel").text = str(userCurrency)
	
