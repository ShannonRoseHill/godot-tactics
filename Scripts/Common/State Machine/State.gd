extends Node

# An abstract State class that can be reused for various purposes
# The state only listens while active
# Prevents behavior like camera movement while using input to navigate menus
class_name State

# Sets up states
func Enter():
	AddListeners()

# Cleans up states
func Exit():
	RemoveListeners()

# Helps clean up any remaining nodes in the tree
func _exit_tree():
	RemoveListeners()

# Creates nodes to listen to Signals from the game environment
func AddListeners():
	pass

# Deletes nodes that are listening for Signals from the game environment	
func RemoveListeners():
	pass
