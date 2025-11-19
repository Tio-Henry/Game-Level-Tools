extends SubViewport

func _ready() -> void:
	await ResourceSaver.save(await generate_image(), "res://assets/resources/scene_objects/icons/" + "speaker.tres") 

func generate_image() -> ImageTexture:
	await RenderingServer.frame_post_draw
	return ImageTexture.create_from_image(get_texture().get_image())
