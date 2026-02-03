@tool # Enables access to BoardCreator methods
extends Node
class_name BoardCreator # This class name helps place the board creator in the inspector plugin

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

# The _ready() method is the equivalent to Unity's Awake() method
# Called when loading an instance of a script component
# Initializes variables or states before the application starts
func _ready():
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
		_UpdateMarker() # Update the position of the TSI

# ######################################### BUTTONS ################################################

# ######## Button Helpers #################

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
		t.Grow() # Adds one tile to the current position; uses Grow() from Tile.gd
		_UpdateMarker() # Updates the position of the tile marker

# Helps Button Two's Shrink() method		
# Removes one tile from the current TSI position		
func _ShrinkSingle(p: Vector2i):
	if not tiles.has(p): # If the tile dictionary contains no entry for the current position, 
		return # do nothing
		
	var t: Tile = tiles[p] # Instantiate a tile using the current position's entry in the tile dictionary
	t.Shrink() # Removes one tile from the current position; uses Shrink() from Tile.gd
	_UpdateMarker() # Updates the position of the tile marker
	
	if t.height <= 0: # If the height of the tile is less than or equal to zero,
		tiles.erase(p) # Removes the current position from the tile dictionary
		t.free() # Frees up memory reserved for the tile


# ######## /Button Helpers ################

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

func GrowArea():
	print("GrowArea Pressed")
	
# Button Five: ShrinkArea

func ShrinkArea():
	print("ShrinkArea Pressed")
	
# Button Six: Save

func Save():
	print("Save Pressed")
	
# Button Seven: Load
 
func Load():
	print("Load Pressed")
	
# Button Eight: SaveJSON

func SaveJSON():
	print("SaveJSON Pressed")
	
# Button Nine: LoadJSON

func LoadJSON():
	print("LoadJSON Pressed")
