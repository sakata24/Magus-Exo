extends Node

var bgm_player: Node = null

func bind_bgm_node(node: Node) -> void:
	if node == null:
		return
	bgm_player = node

func setup_for_scene(scene: Node) -> void:
	if scene == null:
		return
	var player = scene.get_node_or_null("AudioStreamPlayer")
	bind_bgm_node(player)
	play()

func play() -> void:
	if is_instance_valid(bgm_player) and bgm_player.has_method("play"):
		bgm_player.play()

func swap_bgm(bgm_name: String, transition_len: float = 1.0) -> void:
	if not is_instance_valid(bgm_player):
		return
	if bgm_player.has_method("swap_bgm"):
		bgm_player.swap_bgm(bgm_name, transition_len)
	else:
		# fallback: try to set stream by name if possible
		if bgm_player.has_method("set_stream"):
			# no-op: prefer explicit swap_bgm on the bound player
			pass
