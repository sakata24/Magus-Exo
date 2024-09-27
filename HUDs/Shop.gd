extends CanvasLayer

signal opened(me)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(spriteFrames):
	$AnimatedSprite2D.sprite_frames = spriteFrames
	emit_signal("opened", self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
