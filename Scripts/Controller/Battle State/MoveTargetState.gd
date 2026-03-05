extends BattleState

# Transmits signal information on the event of an directional button press
func OnMove(e:Vector2i):
	# Applies translations to directional input depending on the rotation of the camera
	var rotatedPoint = _owner.cameraController.AdjustedMovement(e)
	SelectTile(rotatedPoint + _owner.board.pos) # Places the tile selection indicator, adjusting for camera rotation

# Transmits signal information when a non-directional button is pressed
func OnFire(e:int):
	print("Fire: " + str(e)) # Prints the code of the button pressed

# Transmits signal information when the mouse wheel is scrolled
func Zoom(scroll: int):
	_owner.cameraController.Zoom(scroll) # Uses the cameraController class to zoom the camera

# Transmits signal information when the camera rotates horizontally and vertically
func Orbit(direction: Vector2):
	_owner.cameraController.Orbit(direction) # Uses the cameraController class to rotate the camera
