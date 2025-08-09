class_name UpgradeChest extends Area2D

var interval = 0.002
signal request_menu(menu)
signal player_picked(player: Player)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("request_menu", MenuHandler._add_menu)
	connect("player_picked", MenuHandler.menus[MenuHandler.MENU.SELECTION].set_player_to_buff)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Texture.color.a = $Texture.color.a + interval
	if $Texture.color.a > 0.4:
		interval = -0.002
	elif $Texture.color.a < 0.1:
		interval = 0.002

func _on_body_entered(body):
	if body is Player:
		request_menu.emit(MenuHandler.menus[MenuHandler.MENU.SELECTION])
		player_picked.emit(body)
		self.queue_free()
