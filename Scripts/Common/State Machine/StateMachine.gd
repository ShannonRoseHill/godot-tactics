extends Node

# Hold a reference to the current state to handle switching from one to another
class_name StateMachine

var _currentState: State # Create a variable to store the current state

# Changes from the current state to the next state
func ChangeState(newState: State) -> void:
	if _currentState == newState: # If the current state is the same as the new state,
		return # do nothing
		
	if _currentState: # If in the current state,
		_currentState.Exit() # clear the state node, removing listeners
		
	_currentState = newState # Update the current state with the new state
	
	if _currentState: # If in the current state,
		_currentState.Enter() # create a new state node, adding listeners
