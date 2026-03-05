extends BattleState # Extends the BattleState class, which extends the State class

@export var moveTargetState: State # Link to the moveTargetState node in the Inspector

# Calls the Enter() method from the State class
func Enter():
	super() # Initializes the base Enter() method, adding listeners for input and camera movement
	Init() # Initialize the game board

# Initializes the game board
func Init():
	var saveFile = _owner.board.savePath + _owner.board.fileName # Concatenate the path a saved map file
	_owner.board.LoadMap(saveFile) # Load the map from saveFile
	
	var p:Vector2i = _owner.board.tiles.keys()[0] # Get the first tile in the tile's dictionary
	SelectTile(p) # Select that tile for the initalize position of the tile selection indicator (TSI)
	
	_owner.cameraController.setFollow(_owner.board.marker) # Set the camera to follow the TSI
	
	_owner.stateMachine.ChangeState(moveTargetState) # Transition from state to state as the cursor moves
