extends Node

# The Repeater class limits calls to Input.get_axis()
# Without these limitations, the cursor moves a computationally expensive 60+ times a second
class_name Repeater

const _rate:int = 250 # milliseconds; when held, input buttons will register 4 times every second

var _next: int # Keeps track of elapsed time since a button press
var _axisPos: String # Stores positive axis values
var _axisNeg: String # Stores negative axis values

# Constructor for the Repeater object
func _init(negativeAxis:String, positiveAxis:String):
	_axisNeg = negativeAxis # Initializes negative axis values
	_axisPos = positiveAxis # Initializes positive axis values
	
# Checks each frame to see if there are any new input events
func Update():
	var retValue: int = 0 # A null value means no input information; timer does not start until a button is pressed
	var value:int = roundi(Input.get_axis(_axisNeg, _axisPos)) # Stores information about the cursor's axes
	
	if value != 0: # If the cursor's axis is not equal to zero, meaning a button was pressed,
		if Time.get_ticks_msec() > _next: # and if the time elapsed is greater than the time of the last button press,
			retValue = value # update the axis of the cursor
			_next = Time.get_ticks_msec() + _rate # add 250 milliseconds to the time, determining the next value checkpoint
	else: # Otherwise, no button was pressed
		_next = 0 # So, the Repeater's timer does not start
	
	return retValue # Return the value of the cursor's axis
