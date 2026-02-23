@tool # Enables access to BoardCreator methods
extends Node
class_name BoardCreator # helps place the board creator in the inspector plugin

# The width, depth, and height variable determine the size of the world
# @export exposes the variable in the inspector
@export var width: int = 10
@export var depth: int = 10
@export var height: int = 8

@export var pos: Vector2i # Keeps track of the current position
var _oldPos: Vector2i # Keeps track of the old position when pos is updated in the inspector
var tiles = {} # Dictionary for managing tile values

var tileViewPrefab = preload("res://Prefabs/Tile.tscn") # Loads the tile prefab
var tileSelectionIndictorPrefab = preload("res://Prefabs/Tile Selection Indicator.tscn") # Loads the TSI prefab
var marker # Holds a reference to the instantiated TSI prefab

var _random = RandomNumberGenerator.new() # Used to get random rectangles for the GrowArea and ShrinkArea functions

var savePath = "res://Data/Levels/" # Sets the save location for generated maps
@export var fileName = "savegame.json" # Set the file name for save files

# ##################################################################################################

# The _ready() method is the equivalent to Unity's Awake() method
# Called when loading an instance of a script component
# Initializes variables or states before the application starts
func _ready():
	_random.randomize() # Sets a time-based randomization seed
	
	marker = tileSelectionIndictorPrefab.instantiate() # Instantiate the TSI and saves it as 'marker'
	add_child(marker) # Make the marker a child of BoardCreator
	
	pos = Vector2i(0,0) # Set the initial position of the marker
	_oldPos = pos # _oldPos and current position are the same when the appication starts

# Updates the position of the tile marker
func _UpdateMarker():
	if tiles.has(pos): # Checks the tiles dictionary for the current position
		var t: Tile = tiles[pos] # Creates a tile at the current position
		marker.position = t.center() # Places the TSI over the tile 
	else:
		# If the current position is not in the tiles dictionary,
		# place the TSI at the (x, z) position with a y (the "floor") equal to zero
		marker.position = Vector3(pos.x, 0, pos.y)

# The _process method is the equivalent to Unity's Update() method
# Called every frame; commonly used function to implement any kind of game script	
func _process(_delta):
	if pos != _oldPos: # If the current position and the old position are not the same,
		_oldPos = pos # update the old position with the current position
		_UpdateMarker() # update the position of the TSI

# ######################################### BUTTONS ################################################

# ######## Button Helpers ######################################################

# Helps the _GetOrCreate() method
# Creates a tile instance
func _Create():
	var instance = tileViewPrefab.instantiate() # Stores tile instantiation 
	add_child(instance) # Makes tile instance a child of BoardCreator
	return instance # Returns a tile instance for _GetOrCreate() method

# Helps the _GrowSingle() method
# Manages interactions with the tile dictionary
func _GetOrCreate(p: Vector2i):
	if tiles.has(p): # Parses tile dictionary for current position
		return tiles[p] # Returns tile if one exists at current position
	
	var t: Tile = _Create() # If no tile exists at current position, instantiate one
	t.Load(p, 0) # Position tile at the current (x, z) coordinate with a height of zero
	tiles[p] = t # Add the new tile to the tile dictionary
	return t # Returns a tile for the _GrowSingle() method

# Helps Button One's Grow() method
# Adds one tile to the current TSI position
func _GrowSingle(p: Vector2i):
	var t: Tile = _GetOrCreate(p) # Instantiates a new tile
	if t.height < height: # If the height of the tile is less than the maximum height,
		t.Grow() # adds one tile to the current position; uses Grow() from Tile.gd
		_UpdateMarker() # updates the position of the tile marker

# Helps Button Two's Shrink() method		
# Removes one tile from the current TSI position		
func _ShrinkSingle(p: Vector2i):
	if not tiles.has(p): # If the tile dictionary contains no entry for the current position,
		return # do nothing
		
	var t: Tile = tiles[p] # Instantiate a tile using the current position's entry in the tile dictionary
	t.Shrink() # Removes one tile from the current position; uses Shrink() from Tile.gd
	_UpdateMarker() # Updates the position of the tile marker
	
	if t.height <= 0: # If the height of the tile is less than or equal to zero,
		tiles.erase(p) # removes the current position from the tile dictionary
		t.free() # frees up memory reserved for the tile

# Helps the GrowArea and ShrinkArea functions
# Creates an axis-aligned rectangle by setting one corner and randomizing the edge lengths
# Rect2i a data type consisting of two Vector2i types -- position and size, respectively
func _RandomRect():
	var x = _random.randi_range(0, width - 1) # Sets position[0] 
	var y = _random.randi_range(0, depth - 1) # Sets position[1]
	var w = _random.randi_range(1, width - x) # Sets size[0]
	var h = _random.randi_range(1, depth - y) # Sets size[1]
	return Rect2i(x, y, w, h) # Create a rectangle from the position and size vectors
	
# Helps the GrowArea function
# Grows all of the tiles in a randomly generated axis-aligned rectangle
func _GrowRect(rect: Rect2i):
	# Uses a nested loop to select all the tiles in a rectangular area
	for y in range(rect.position.y, rect.end.y): # Iterates all positions in the height dimension
		for x in range(rect.position.x, rect.end.x): # Iterates all positions in the width dimension
			var p = Vector2i(x,y) # Creates a vector for each (x,y) position
			_GrowSingle(p) # Grows the tile at that position
		
# Helps the ShrinkArea function
# Shrinks all of the tiles in a randomly generated axis-aligned rectangle			
func _ShrinkRect(rect: Rect2i):
	# Uses a nested loop to select all the tiles in a rectangular area
	for y in range(rect.position.y, rect.end.y): # Iterates all positions in the height dimension
		for x in range(rect.position.x, rect.end.x): # Iterates all positions in the width dimension
			var p = Vector2i(x,y) # Creates a vector for each (x,y) position
			_ShrinkSingle(p) # Shrinks the tile at that position
			
# ######## /Button Helpers #####################################################

# Button One: Clear
# Completely clears all tiles in the BoardCreator
func Clear():
	for key in tiles: # Loops through all keys in the tiles dictionary
		tiles[key].free() # Frees memory of key:value pairs
	tiles.clear() # Clears the tiles dictionary

# Button Two: Grow
# Adds one tile to the current TSI position
func Grow():
	_GrowSingle(pos)

# Button Three: Shrink
# Removes one tile from the current TSI position	
func Shrink():
	_ShrinkSingle(pos)
	
# Button Four: GrowArea
# Grows tiles in a randomly generated axis-aligned rectangle
func GrowArea():
	var r: Rect2i = _RandomRect()
	_GrowRect(r)
	
# Button Five: ShrinkArea
# Shrinks tiles in a randomly generated axis-aligned rectangle
func ShrinkArea():
	var r: Rect2i = _RandomRect()
	_ShrinkRect(r)
	
# Button Six: Save
# Save the board as binary data to a .txt file
func Save():
	var saveFile = savePath + fileName # Concatenates savePath and fileName for complete saveFile path
	SaveMap(saveFile)
		
# Button Seven: Load
# Loads a saved board's binary data from a .txt file 
func Load():
	var saveFile = savePath + fileName # Concatenates savePath and fileName for complete saveFile path
	LoadMap(saveFile)
	
# Button Eight: SaveJSON
# Saves the board's data in JSON
func SaveJSON():
	var saveFile = savePath + fileName # Concatenates savePath and fileName for complete saveFile path
	SaveMapJSON(saveFile)
	
# Button Nine: LoadJSON
# Loads a board from a JSON file
func LoadJSON():
	var saveFile = savePath + fileName # Concatenates savePath and fileName for complete saveFile path
	LoadMapJSON(saveFile)

####################################################################################################
# Algorithms for Save and Load buttons

# Save the board as binary data to a .txt file
func SaveMap(saveFile):
	var saveGame = FileAccess.open(saveFile, FileAccess.WRITE) # Opens the saveFile with Write access
	var version = 1 # Version number to track changes
	var size = tiles.size() # Stores the number of tiles in a dictionary
	
	saveGame.store_8(version) # Writes version information as 8 bits; advances the file cursor by one byte
	saveGame.store_16(size) # Writes the tile dictionary as 16 bits; advances the file cursor by two bytes
	
	for key in tiles: # For every tile in the tile dictionary,
		saveGame.store_8(key.x) # writes the x-coordinate component of the tile position; advances the file cursor by one byte
		saveGame.store_8(key.y) # writes the z-coordinate component of the tile position; advances the file cursor by one byte
		saveGame.store_8(tiles[key].height) # writes the height component of the tile position; advances the file cursor by one byte
		
	saveGame.close() # Close the saveGame file after writing data

# Loads a saved board's binary data from a .txt file 
func LoadMap(saveFile):
	Clear() # Clears the board of any existing tiles to avoid conflicts
	
	if not FileAccess.file_exists(saveFile): # If no saveFile exists at the concatenated path,
		return # return nothing
	
	var saveGame = FileAccess.open(saveFile, FileAccess.READ) # Open the saveFile with Read access
	var _version = saveGame.get_8() # Reads 8 bits for the map version; advances the file cursor by one byte
	var size = saveGame.get_16() # Reads 16 bits for the tile dictionary; advances the file cursor by two bytes 
	
	for i in range(size): # For every tile in saveGame's tile dictionary
		var saveX = saveGame.get_8() # read 8 bits for the x-coordinate component of the tile position; advances the file cursor by one byte
		var saveZ = saveGame.get_8() # read 8 bits for the z-coordinate component of the tile position; advances the file cursor by one byte
		var saveHeight = saveGame.get_8() # read 8 bits for the height component of the tile position; advances the file cursor by one byte
		
		var t: Tile = _Create() # create a new tile object
		t.Load(Vector2i(saveX, saveZ), saveHeight) # load the tile's x, z, and height components
		tiles[Vector2i(t.pos.x, t.pos.y)] = t # adds the tile to the board's tiles dictionary
	
	saveGame.close() # Closes the saveGame file when finished reading data
	_UpdateMarker() # Updates the position of the tile marker

# Saves the board's data in JSON
func SaveMapJSON(saveFile):
	var mainDict = { # Create a dictionary defining the structure of the JSON file
		"version": "1.0.0", # Version information to track changes to the board
		"tiles": [] # Stores all tiles in an array
	}
	
	for key in tiles: # For every tile in the tiles dictionary,
		var saveDict = { # create a dictionary to manage the positional components of the tile
			"posX" : tiles[key].pos.x, # store the x-coordinate component of the tile
			"posZ" : tiles[key].pos.y, # store the y-coordinate component of the tile
			"height" : tiles[key].height, # store the height component of the tile
		}
		mainDict["tiles"].append(saveDict) # store the tile in the tiles array of the mainDict
		
	var saveGame = FileAccess.open(saveFile, FileAccess.WRITE) # Open the saveFile with Write access
	
	var jsonString = JSON.stringify(mainDict, "\t", false) # Convert mainDict to JSON text for serialization
	saveGame.store_line(jsonString) # Write the jsonString to the saveGame file
	
	saveGame.close() # Close the saveGame file after writing data

# Loads a board from a JSON file	
func LoadMapJSON(saveFile):
	Clear() # Clear the board of any existing tiles to avoid conflicts
	
	if not FileAccess.file_exists(saveFile): # If no saveFile exists at the location,
		return # do nothing; there is no file to return
	
	var saveGame = FileAccess.open(saveFile, FileAccess.READ) # If a saveGame file exists, open it with Read access
	
	var jsonText = saveGame.get_as_text() # Load the saveGame data as a string
	var json = JSON.new() # Create a new JSON object
	var parseResult = json.parse(jsonText) # Populate the JSON object with the saveGame's jsonText
	
	if parseResult != OK: # If unable to parse jsonText,
		print("Error %s reading json file." % parseResult) # throw an error
		return # return nothing
	
	var data = {} # If the jsonText parses successfully, create a dictionary to hold tile data
	data = json.get_data() # Store JSON tile information in the data dictionary
	
	for mtile in data["tiles"]: # For every tile in the data dictionary,
		var t: Tile = _Create() # create a new Tile object
		t.Load(Vector2(mtile["posX"], mtile["posZ"]), mtile["height"]) # load the tile's x, z, and height components
		tiles[Vector2i(t.pos.x, t.pos.y)] = t  # adds the tile to the board's tiles dictionary
	
	saveGame.close() # Close the saveGame file when finished loading data
	_UpdateMarker() # Update the position of the tile selection marker

####################################################################################################
