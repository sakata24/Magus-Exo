class_name BGMPlayer extends AudioStreamPlayer

var dungeon_delving_bgm = preload("res://Resources/audio/music/Dungeon_Delving.mp3")
var crystal_mirror_bgm = preload("res://Resources/audio/music/crystal_mirror.mp3")
var anonymous_figure_bgm = preload("res://Resources/audio/music/anonymous_figure.ogg")
var just_a_hero_bgm = preload("res://Resources/audio/music/just_a_hero.ogg")

var currently_playing: String = "anonymous_figure"

# change bgm to the new based on string
func swap_bgm(bgm_name: String, transition_len: float):
	if bgm_name == currently_playing:
		return
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -80.0, transition_len)
	tween.tween_callback(func(): 
		match bgm_name:
			"dungeon_delving":
				set_stream(dungeon_delving_bgm)
				currently_playing = "dungeon_delving"
			"crystal_mirror":
				set_stream(crystal_mirror_bgm)
				currently_playing = "crystal_mirror"
			"anonymous_figure":
				set_stream(anonymous_figure_bgm)
				currently_playing = "anonymous_figure"
			"just_a_hero":
				set_stream(just_a_hero_bgm)
				currently_playing = "just_a_hero"
			_: 
				set_stream(dungeon_delving_bgm)
				currently_playing = "dungeon_delving"
		self.volume_db = -5.0
		play())
	tween.play()

# on finish, loop bgm
func _on_finished() -> void:
	play()
