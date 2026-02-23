extends Node

# The Godot Engine registers mouse scrolls as button presses instead of an axis
# Camera movement must be smooth, but calls for mouse wheel input should be limited to save resources
# Mouse scrolls register as is_action_just_pressed(), NOT is_action_pressed()
# is_action_pressed() checks if the camera_activate button is pressed
class_name ButtonRepeater

const _rate = 50 # milliseconds; when pressed, input buttons will register 20 times every second 
var _next: int # Keeps track of elapsed time since a button press
var _button: String # Stores a reference to button presses

# Constructor for the ButtonRepeater
func _init(limitButton:String):
	_button = limitButton # Initializes with a button

# Checks each frame to see if there are any new input events
func Update():
	if Input.is_action_just_pressed(_button): # If the mouse wheel is scrolled,
		_next = Time.get_ticks_msec() + _rate # add 50 milliseconds to the time, determining the next value checkpoint 
		return true # return mouse scrolls as rate limited button input
	
	if Input.is_action_pressed(_button): # If the camera_activate button is pressed,
		if Time.get_ticks_msec() > _next: # and if the time elapsed is greater than the last timer checkpoint,
			_next = Time.get_ticks_msec() + _rate # add 50 milliseconds to the time, setting the next checkpoint
			return true # # return rate limit button input
	
	return false # Do nothing if non-camera button are pressed
