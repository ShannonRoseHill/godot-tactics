@tool # Enables the board script to access Tile methods
extends Node
class_name Tile

# Creates a constant for the height of tile steps
const stepHeight: float = 0.25

var pos: Vector2i # Represents a tile's X and Z coordinates
var height: int # Represents a tile's Y coordinate

# Convenience function for placing objects and characters on a tile's surface
func center() ->Vector3:
	# pos.x is the tile's X coordinate
	# pos.y is the tile's Z coordinate
	# (height * stepHeight) modifies the height of the tile's surface
	return Vector3(pos.x, height * stepHeight, pos.y)

# Updates the scale of modified tiles
func Match():
	# Scale tile to the correct height
	self.scale = Vector3(1, height * stepHeight, 1)
	# Shifts the tile up half the height, because its pivot point is a the center
	self.position = Vector3(pos.x, height * stepHeight / 2.0, pos.y)

# The board is created by growing and shrinking tiles
# The Grow() and Shrink() functions increment and decrement the tile height, respectively
func Grow():
	height += 1
	Match() # Updates the scale of the modified tile
		
func Shrink():
	height -= 1
	Match()

# Sets a tile's X, Y, and Z coordinates
func Load(p: Vector2i, h: int):
	pos = p # Sets the X and Z coordinates
	height = h # Sets the Y coordinate
	Match()

# Loads the tile's coordinates as a vector
func LoadVector(v: Vector3):
	Load(Vector2i(v.x, v.z), v.y)
