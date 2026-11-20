@tool
extends Control

var plugin: EditorPlugin

var engine_control: Control
var window_create_level: Window = load("res://addons/Game-Level-Tools/nodes/create_level.tscn").instantiate()

var level_base: String = "res://assets/game/loops/loop_base.tscn"
var level_directory: String = "res://assets/game/loops/"
var level_array: Array[Node3D] = []

var categories_array: Array[String] = []

var play: bool = false

@onready var level_container: VBoxContainer = $VBoxContainer/ScrollContainer/LevelContainer
@onready var categories_container: HBoxContainer = $VBoxContainer/CategoriesContainer

func _exit_tree() -> void:
	engine_control = null
	window_create_level.queue_free()
	for item in level_array:
		item.queue_free()
	level_array.clear()

func _ready() -> void:
	if Engine.is_editor_hint():
		engine_control = EditorInterface.get_base_control()
		$VBoxContainer/ScrollContainer/LevelContainer/AddLevel.icon = engine_control.get_theme_icon("Add","EditorIcons")
	update_list()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		verify_scene_open(EditorInterface.get_edited_scene_root())

func verify_scene_open(node: Node) -> void:
	for item in range(level_array.size()):
		if node:
			level_container.get_child(item, true).get_child(0).disabled = (
				level_array[item].scene_file_path == node.scene_file_path
				)
		else:
			level_container.get_child(item, true).get_child(0).disabled = false

func update_categories() -> void:
	if categories_array.size() > 0:
		categories_array.clear()
	if categories_container.get_children(true).size() > 1:
		for item in categories_container.get_children(true):
			if not item.name == "AddLevel":
				item.queue_free()

func update_list() -> void:
	if level_array.size() > 0:
		level_array.clear()
	if level_container.get_children(true).size() > 1:
		for item in level_container.get_children(true):
			if not item.name == "AddLevel":
				item.queue_free()
	for item in DirAccess.get_files_at(level_directory):
		level_array.append(load(level_directory + item).instantiate())
	for level in level_array:
		var h_box: HBoxContainer = HBoxContainer.new()
		var button_open: Button = Button.new()
		var button_play: Button = Button.new()
		button_open.pressed.connect(open_scene.bind(level))
		button_play.pressed.connect(play_scene.bind(level))
		button_open.text = level.name
		button_open.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if Engine.is_editor_hint():
			button_play.icon = engine_control.get_theme_icon("Play","EditorIcons")
		h_box.add_child(button_open)
		h_box.add_child(button_play)
		level_container.add_child(h_box,false,Node.INTERNAL_MODE_FRONT)

func open_scene(level: Node3D) -> void:
	EditorInterface.inspect_object(level)
	verify_scene_open(level)
	EditorInterface.open_scene_from_path(level.scene_file_path)

func play_scene(level: Node3D) -> void:
	EditorInterface.play_custom_scene(level.scene_file_path)
	
func create_level(level_name: String, base: , level_path: String) -> void:
	if not DirAccess.get_files_at(level_directory).has(level_path.get_file()): 
		if not ResourceSaver.save(load(level_base), level_path):
			var new_level: PackedScene = load(level_path)
			var level_instance: Node3D = new_level.instantiate()
			level_instance.name = level_name
			new_level.pack(level_instance)
			ResourceSaver.save(new_level)
			open_scene(level_instance)
			update_list()
		else:
			printerr("Failed in create new level")
	else:
		printerr("The ",level_path.get_file(), " is already exists")

func _on_add_level_pressed() -> void:
	add_child(window_create_level)
	window_create_level.level_base.text = level_base
	window_create_level.level_path.text = level_directory
	window_create_level.popup_centered()
