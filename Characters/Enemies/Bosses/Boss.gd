# abstract class to represent a boss. essentially a monster with additional functionality

class_name Boss extends Monster

var boss_name: String

signal health_changed
signal boss_dead

func _ready():
	cc_immune = true
	droppable = false
	add_to_group("monsters")
	await call_deferred("_set_player")
	emit_signal("health_changed", maxHealth, true)

func _set_player():
	if get_tree().get_nodes_in_group("players").size() > 0:
		player = get_tree().get_nodes_in_group("players")[0]

func _hit(dmg: DamageObject):
	super(dmg)
	health_changed.emit(self.health, false)

# when i die
func die():
	emit_signal("give_xp", bestowedXp)
	emit_signal("boss_dead")
	player.get_parent().get_node("HUD").get_node("MarginContainer/BossBar").visible = false # CHANGE THIS AFTER UI REFACTORING 
	var drop
	match randi_range(0, 2):
		0: 
			drop = upgradeDrop.instantiate()
		_:
			drop = null
	if drop != null:
		drop.position = position
		get_parent().add_child(drop)
	for enemy in get_tree().get_nodes_in_group("monsters"):
		enemy.queue_free()
	queue_free()
