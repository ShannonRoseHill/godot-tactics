extends Node
class_name InputController

signal moveEvent(point:Vector2i) # Listens for directional input
signal fireEvent(button:int) # Listens for non-directional button input
signal quitEvent() # Listens for signals to close the game's screen
signal cameraRotateEvent(point:Vector2) # Listens for camera rotation signals
signal cameraZoomEvent(scroll:int) # Listens for camera zoom signals

# Repeater class variables for directional buttons
# To set button mappings: Project-> Project Settings-> Input Map
var _hor:Repeater = Repeater.new("move_left", "move_right") # Initializes a Repeater object to manage horizontal input
var _ver:Repeater = Repeater.new("move_up", "move_down") # Initializies a Repeater object to manage vertical input

# ButtonRepeater class variables for camera scroll input
# zoom_up: Mouse Wheel Up (-1)
# zoom_down: Mouse Wheel Down (1)
# To set mouse wheel mappings: Project-> Project Settings-> Input Map
var _camZoomUp:ButtonRepeater = ButtonRepeater.new('zoom_up') # Initializes a ButtonRepeater object to manage zoom_up input
var _camZoomDown:ButtonRepeater = ButtonRepeater.new('zoom_down') # Initializes a ButtonRepeater object to manage zoom_down input

var _lastMouse:Vector2 # Keeps track of the mouse's position when camera mode is activated

# Stores the button names for non-directional input
# To set button mappings: Project-> Project Settings-> Input Map
var buttons = [
	'fire_1', # Sony X, Nintendo B, Keyboard Enter
	'fire_2', # Sony O, Nintendo A, Keyboard Shift
	'fire_3', # Sony Square, Nintendo Y
	'fire_4' # Sony Triangle, Nintendo X
]

# Updates the cursor's axis information
func _process(delta):
	var x = _hor.Update() # Stores the cursor's horizontal position
	var y = _ver.Update() # Stores the cursor's vertical position
	
	var camX = Input.get_axis('camera_right', 'camera_left') # Stores the camera's horizontal axis
	var camY = Input.get_axis('camera_down', 'camera_up') # Store's the camera's vertical axis
	
	if x != 0 || y != 0: # If x or y are not 0, a button was pressed;
		moveEvent.emit(Vector2i(x,y)) # using the (x,y) vector to update the curor's position
	
	for i in range(buttons.size()): # For every button name in the buttons array,
		if Input.is_action_just_pressed(buttons[i]): # check if the button was just pressed
			fireEvent.emit(i) # if so, the button emits a signal to the environment
	
	if Input.is_action_just_pressed('quit'): # If the 'quit' button (Escape) is pressed,
			quitEvent.emit() # close the game's screen
	
	################################################################################################
	# Camera Input
	
	if _camZoomUp.Update(): # If the mouse wheel is scrolled up,
		cameraZoomEvent.emit(-1) # emit the zoom_up signal to the environment
		
	if _camZoomDown.Update(): # If the mouse wheel is scrolled down,
		cameraZoomEvent.emit(1) # emit the zoom_down signal to the environment
	
	if camX != 0 || camY != 0: # If either camX or camY are not equal to 0,
		cameraRotateEvent.emit(Vector2(camX, camY)) # emit the updated position of the mouse
	
	if Input.is_action_just_pressed('camera_activate'): # If there is mouse wheel input while camera mode is activated,
		_lastMouse = get_viewport().get_mouse_position() # update the mouse wheel position within the viewport
	
	if Input.is_action_pressed('camera_activate'): # If the camera_activate button is pressed,
		var currentMouse:Vector2 = get_viewport().get_mouse_position() # get the mouse's position within the viewport
		
		if _lastMouse != currentMouse: # If the last mouse position is not the same as the current mouse position,
			var mouseVector:Vector2 = _lastMouse - currentMouse # keep track of the distance between the positions
			_lastMouse = currentMouse # update the previous mouse position with the current mouse position
			var vectorLimit = 10 # limit the distance of the difference vetween the vectors
			var newVector:Vector2 = mouseVector/vectorLimit # normalize the vector to work with joystick values
			cameraRotateEvent.emit(newVector) # emit mouse position using a vector
