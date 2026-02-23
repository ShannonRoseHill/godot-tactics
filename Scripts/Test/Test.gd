extends Node

var _owner: BattleController # Grants access to BattleController's inputController and board objects

# Prepares the board node
func _ready():
	_owner = get_node("../") # Stores a reference to the BattleController node; goes up one level of the node tree
	
	_owner.cameraController.setFollow(_owner.board.marker) # Assigns a camera follower to the tile selection indicator
	
	var saveFile = _owner.board.savePath + _owner.board.fileName # Gets the saveFile by concatenating its path
	_owner.board.LoadMap(saveFile) # Loads the saveFile
	
	AddListeners() # Listens for Signals

 # Called when destroying a node
func _exit_tree():
	RemoveListeners() # Cleans up any nodes listening for Signals

# Creates nodes to listen to Signals from the game environment
func AddListeners():
	_owner.inputController.moveEvent.connect(OnMove) # Connects directional button signals to the InputController
	_owner.inputController.fireEvent.connect(OnFire) # Connects non-directional button signals to the InputController
	_owner.inputController.quitEvent.connect(OnQuit) # Connects Escape button signal to the InputController 

# Deletes nodes that are listening for Signals from the game environment
func RemoveListeners():
	_owner.inputController.moveEvent.disconnect(OnMove) # Ceases directional button signals to the InputController
	_owner.inputController.fireEvent.disconnect(OnFire) # Ceases non-directional button signals to the InputController
	_owner.inputController.quitEvent.disconnect(OnQuit) # Ceases Escape button signal to the InputController

# Transmits signal information on the event of an directional button press
func OnMove(e:Vector2i):
	# Applies translations to directional input depending on the rotation of the camera
	var rotatedPoint = _owner.cameraController.AdjustedMovement(e)
	_owner.board.pos += rotatedPoint # Update the position of the cursor

# Transmits signal information when a non-directional button is pressed
func OnFire(e:int):
	print("Fire: " + str(e)) # Prints the code of the button pressed

# Transmits the Escape button's signal information
func OnQuit():
	get_tree().quit() # Closes the tree containing the BattleController node
