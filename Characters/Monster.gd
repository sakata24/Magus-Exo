extends CharacterBody2D

var damageNumber = preload("res://HUDs/DamageNumber.tscn")

# is it mad
var aggro = false
# reference to chase the player
var player = CharacterBody2D
# how fast i move
var speed = 50
# my health
var health = 50
# max health
var maxHealth = 50
# exp i give
var bestowedXp = 1

signal giveXp(xp)

func _ready():
	pass

func init():
	pass

# handle internal processes
func _process(delta):
	if health <= 0:
		die()

# make the monster move
func _physics_process(delta):
	if aggro:
		chase(delta)

# chases the player
func chase(delta):
	if position.distance_to(player.position) > 2:
		set_velocity(position.direction_to(player.position) * speed)
		move_and_slide()

# hit by something
func _hit(dmg_to_take):
	health -= dmg_to_take
	print("i took ", dmg_to_take, " dmg")
	var dmgNum = damageNumber.instantiate()
	get_parent().add_child(dmgNum)
	dmgNum.set_value_and_pos(self.global_position, dmg_to_take)
	

# when player makes me mad
func _on_AggroRange_body_entered(body: CharacterBody2D):
	if body:
		if body.name == "Player":
			aggro = true
			player = body

# when i die
func die():
	emit_signal("giveXp", bestowedXp)
	queue_free()
