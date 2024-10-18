extends Spell


# Called when the node enters the scene tree for the first time.
func _ready():
	dmg = 7
	cooldown = 1.2
	self.modulate.a = 1

func init(skillDict, castTarget, caster):
	super(skillDict, castTarget, caster)
	var offset = (castTarget - caster.global_position).normalized() * 58
	self.position = caster.global_position + offset
	self.look_at(castTarget)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_TimeoutTimer_timeout():
	self.set_collision_mask_value(2, !get_collision_mask_value(2))
	$TimeoutTimer.start()
