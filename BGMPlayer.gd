class_name BGMPlayer extends AudioStreamPlayer

var dungeon_delving_bgm = preload("res://Resources/audio/music/Dungeon_Delving.mp3")
var crystal_mirror_bgm = preload("res://Resources/audio/music/crystal_mirror.mp3")

var currently_playing: String = "dungon_delving"

# change bgm to the new based on string
func swap_bgm(bgm_name: String, transition_len: float):
	if bgm_name == currently_playing:
		return
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -80.0, transition_len/2.0)
	tween.tween_callback(func(): 
		match bgm_name:
			"dungeon_delving": set_stream(dungeon_delving_bgm)
			"crystal_mirror": set_stream(crystal_mirror_bgm)
			_: set_stream(dungeon_delving_bgm)
		play()
		var new_tween = create_tween()
		new_tween.tween_property(self, "volume_db", -5.0, transition_len/2.0)
		new_tween.play())
	tween.play()

# on finish, loop bgm
func _on_finished() -> void:
	play()
