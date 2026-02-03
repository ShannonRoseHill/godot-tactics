@tool # Allows access in the editor
extends EditorInspectorPlugin # This plugin modifies the inspector

# If the object is a BoardCreator, show the plugin within the editor
func _can_handle(object):
	if object is BoardCreator: # class_name from BoardCreator.gd
		return true
	return false

func _parse_begin(object):
	# Button One: Clear
	var btn_clear = Button.new()
	btn_clear.set_text("Clear")
	btn_clear.pressed.connect(object.Clear)
	add_custom_control(btn_clear)
	
	# Button Two: Grow
	var btn_grow = Button.new()
	btn_grow.set_text("Grow")
	btn_grow.pressed.connect(object.Grow)
	add_custom_control(btn_grow)
	
	# Button Three: Shrink
	var btn_shrink = Button.new()
	btn_shrink.set_text("Shrink")
	btn_shrink.pressed.connect(object.Shrink)
	add_custom_control(btn_shrink)
	
	# Button Four: GrowArea
	var btn_growArea = Button.new()
	btn_growArea.set_text("Grow Area")
	btn_growArea.pressed.connect(object.GrowArea)
	add_custom_control(btn_growArea)
	
	# Button Five: ShrinkArea
	var btn_shrinkArea = Button.new()
	btn_shrinkArea.set_text("Shrink Area")
	btn_shrinkArea.pressed.connect(object.ShrinkArea)
	add_custom_control(btn_shrinkArea)
	
	# Button Six: Save
	var btn_save = Button.new()
	btn_save.set_text("Save")
	btn_save.pressed.connect(object.Save)
	add_custom_control(btn_save)
	
	# Button Seven: Load
	var btn_load = Button.new()
	btn_load.set_text("Load")
	btn_load.pressed.connect(object.Load)
	add_custom_control(btn_load)
	
	# Button Eight: SaveJSON
	var btn_saveJSON = Button.new()
	btn_saveJSON.set_text("Save JSON")
	btn_saveJSON.pressed.connect(object.SaveJSON)
	add_custom_control(btn_saveJSON)
	
	# Button Nine: LoadJSON
	var btn_loadJSON = Button.new()
	btn_loadJSON.set_text("Load JSON")
	btn_loadJSON.pressed.connect(object.LoadJSON)
	add_custom_control(btn_loadJSON)
