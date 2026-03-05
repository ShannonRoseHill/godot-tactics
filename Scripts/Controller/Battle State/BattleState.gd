extends State

class_name BattleState

var _owner: BattleController # Grants access to BattleController's inputController and board objects

func _ready():
	_owner = get_node("../../") # Make the battle state node a child of the state machine node
	
# Creates nodes to listen to Signals from the game environment
func AddListeners():
	_owner.inputController.moveEvent.connect(OnMove) # Connects directional button signals to the InputController
	_owner.inputController.fireEvent.connect(OnFire) # Connects non-directional button signals to the InputController
	_owner.inputController.quitEvent.connect(OnQuit) # Connects Escape button signal to the InputController 
	_owner.inputController.cameraZoomEvent.connect(Zoom) # Connects mouse scroll input to the inputController
	_owner.inputController.cameraRotateEvent.connect(Orbit) # Connects mouse position vector to the inputController

# Deletes nodes that are listening for Signals from the game environment
func RemoveListeners():
	_owner.inputController.moveEvent.disconnect(OnMove) # Ceases directional button signals to the InputController
	_owner.inputController.fireEvent.disconnect(OnFire) # Ceases non-directional button signals to the InputController
	_owner.inputController.quitEvent.disconnect(OnQuit) # Ceases Escape button signal to the InputController
	_owner.inputController.cameraZoomEvent.disconnect(Zoom) # Ceases mouse scroll signals to the inputController
	_owner.inputController.cameraRotateEvent.disconnect(Orbit) # Disconnects mouse position vector from the inputController
	
func OnMove(e:Vector2i):
	pass
	
func OnFire(e:int):
	pass

# Set the tile selection indicator on the board using a positional vector
func SelectTile(p:Vector2i):
	if _owner.board.pos == p: # If the TSI's location is the same as the vector,
		return # do nothing
	
	_owner.board.pos = p # Set the TSI at the correct position

# Transmits the Escape button's signal information
func OnQuit():
	get_tree().quit() # Closes the tree containing the BattleController node


func Zoom(scroll: int):
	pass

func Orbit(direction: Vector2):
	pass
