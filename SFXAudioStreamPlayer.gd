class_name SFXAudioStreamPlayer extends AudioStreamPlayer

var hitmark_sfx = preload("res://Resources/audio/sfx/hitmark.ogg")

func play_hitmark(dmg):
	self.stream = hitmark_sfx
	self.pitch_scale = randf_range(0.65, 0.85)
	self.play()
