# Swarm:
# Creation: flow + wither
# swarm of particles that deal damage

class_name SwarmReaction extends Reaction

var swarm_particle_scene = preload("res://Abilities/Reactions/SwarmParticle.tscn")

var BASE_SWARM_RADIUS = 32
var swarm_radius = 32
var target: Enemy
var speed = 50
var parents

func _ready():
	# start tracking target
	find_target()

# assign instance variables
func init(reaction_components: Dictionary):
	swarm_radius = BASE_SWARM_RADIUS
	parents = reaction_components
	# reparent myself to main to not despawn when parents react and destroy themselves
	reparent(parents["source"].get_parent(), true)
	# spawn the correct amt of particles
	spawn_n_swarm_particles(10 + parents["source"].dmg/2)
	spawn_reaction_name("swarm!", reaction_components["reactant"], Color("#82b1ff"), Color("#591b82"))
	super(reaction_components)

func _physics_process(delta: float) -> void:
	# start tracking another target if need to
	if target:
		# simple move eqn
		global_position += global_position.direction_to(target.global_position) * speed * delta
	else:
		find_target()
	

# spawns n swarm particles
func spawn_n_swarm_particles(n: int):
	for num in n:
		# instantiate the particle and add it to my children
		var new_particle = swarm_particle_scene.instantiate()
		add_child(new_particle)

# assigns the target variable if needed
func find_target():
	for enemy: Enemy in get_tree().get_nodes_in_group("monsters"):
		# check for closest target in monsters
		if !target or self.global_position.distance_to(enemy.global_position) < self.global_position.distance_to(target.global_position):
			target = enemy

func _on_lifetime_timer_timeout() -> void:
	queue_free()
