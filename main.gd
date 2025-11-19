@tool
extends EditorPlugin

var dock: Control = preload("res://addons/game_level_tools/interfaces/tools.tscn").instantiate()
var level_manage: Control = preload("res://addons/game_level_tools/interfaces/level_manage.tscn").instantiate()
var filesystem: EditorFileSystem = EditorInterface.get_resource_filesystem()

func _enter_tree() -> void:
	filesystem.filesystem_changed.connect(level_manage.update_list)
	add_control_to_bottom_panel(dock,"Level Tools")
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR,level_manage)
	level_manage.plugin = self
	
func _exit_tree() -> void:
	remove_control_from_bottom_panel(dock)
	dock.queue_free()
	dock = null
	filesystem.filesystem_changed.disconnect(level_manage.update_list)
	remove_control_from_docks(level_manage)
	level_manage.queue_free()
	level_manage = null
