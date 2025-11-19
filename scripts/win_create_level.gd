@tool
extends Window

@onready var level_name: LineEdit = $Control/MarginContainer/VBoxContainer/LevelName/LineEdit
@onready var level_base: LineEdit = $Control/MarginContainer/VBoxContainer/LevelBase/LineEdit
@onready var level_path: LineEdit = $Control/MarginContainer/VBoxContainer/LevelPath/LineEdit

func close_window() -> void:
	self.hide()
	$"../".call_deferred("remove_child", self) 

func _process(_delta: float) -> void:
	$Control/MarginContainer/VBoxContainer/HBoxContainer/CreateBtn.disabled = (
		level_name.text == "" or \
		level_base.text == "" or \
		not FileAccess.file_exists(level_base.text) or \
		level_path.text == "" or \
		not DirAccess.dir_exists_absolute(level_path.text.get_base_dir()) or \
		FileAccess.file_exists(level_path.text)
	)

func _on_create_btn_pressed() -> void:
	$"../".create_level(level_name.text,level_path.text)
	close_window()

func _on_level_name_text_changed(new_text: String) -> void:
	level_path.text = $"../".level_directory + new_text.to_snake_case() + ".tscn"
