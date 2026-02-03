@tool # Allows the plugin to work in the editor
extends EditorPlugin

var plugin # Creates a variable to store the plugin

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	plugin = preload("res://addons/BoardCreatorInspector/BoardCreatorInspector.gd").new()
	add_inspector_plugin(plugin)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_inspector_plugin(plugin)
