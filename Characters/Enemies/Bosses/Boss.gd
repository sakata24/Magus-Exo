# abstract class to represent a boss. essentially a monster with additional functionality

class_name Boss extends Monster

var boss_name: String

signal health_changed
signal boss_dead

var signals : Array[String] = ["health_changed", "boss_dead"]
var focus_target: Node2D = null

func _ready():
	cc_immune = true
	droppable = false
	add_to_group("monsters")
	_set_player()
	emit_signal("health_changed", maxHealth, true)

func _set_player():
	# for now, randomly choose player, except theres only one so.
	player = get_tree().get_nodes_in_group("players")[randi_range(0, get_tree().get_nodes_in_group("players").size() - 1)]

func hit(dmg: DamageObject):
	super(dmg)
	health_changed.emit(self.health, false)

# when i die
func die():
	emit_signal("give_xp", bestowedXp, ["sunder", "entropy", "growth", "construct", "flow", "wither"])
	emit_signal("boss_dead")
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

func set_focus_target(target: Node2D):
	focus_target = target
