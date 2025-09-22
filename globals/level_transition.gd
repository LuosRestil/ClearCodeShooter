extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func load_level(file_path: String):
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(file_path)
	animation_player.play_backwards("fade_to_black")
