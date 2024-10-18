extends Spell


# Called when the node enters the scene tree for the first time.
func _ready():
	dmg = 11
	cooldown = 0.3

func init(skillDict, castTarget, caster):
	super(skillDict, castTarget, caster)
	var offset = (castTarget - caster.global_position).normalized() * 108
	self.position = caster.global_position + offset
	self.look_at(caster.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
