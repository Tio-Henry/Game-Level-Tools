@tool
extends Control

var engine_control

var folder_assets: PackedStringArray = [
	"res://assets/resources/puzzle_object/", 
	"res://assets/resources/scene_objects/"
	]

@onready var h_categories: HBoxContainer = $MarginContainer/ScrollContainer/HBoxContainer

func _ready() -> void:
	scan_folders()

func scan_folders() -> void:
	for folder: String in folder_assets:
		var v_category: VBoxContainer = load("res://addons/game_level_tools/nodes/v_category.tscn").instantiate()
		v_category.name = folder.get_slice("/",4)
		v_category.get_node(^"Label").text = str(folder.get_slice("/",4)).capitalize()
		h_categories.add_child(v_category)
		for asset: String in DirAccess.get_files_at(folder):
			var button: Button = Button.new()
			button.text = str(asset.get_basename()).capitalize()
			button.expand_icon = false
			if DirAccess.dir_exists_absolute(str(folder + "icons/")):
				var icon_file: String = folder + "icons/" + asset.get_basename() + ".tres"
				if FileAccess.file_exists(icon_file):
					button.icon = load(icon_file)
			button.pressed.connect(add_object.bind(str(folder + asset)))
			v_category.get_node("PanelContainer/ScrollContainer/VCategory").add_child(button)

func add_object(object_path: String) -> void:
	var scene_editor: Node = EditorInterface.get_edited_scene_root()
	if scene_editor is Phase:
		var instance: Node = load(object_path).instantiate()
		scene_editor.add_child(instance, true)
		instance.owner = scene_editor
		EditorInterface.mark_scene_as_unsaved()
		instance = null
