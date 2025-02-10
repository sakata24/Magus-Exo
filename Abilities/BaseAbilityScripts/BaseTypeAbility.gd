# Class responsible for handling reactions of a "type"
# Meant to act as a parent for <type>Ability.gd

class_name BaseTypeAbility extends Area2D

var myMovement: Movement
var mySpawnBehavior: SpawnBehavior
var myModifiers = []

var abilityID = 0
var speed = 300
var velocity = Vector2.ZERO
var dmg = 10
var timeout = 1
var lifetime = 1
var cooldown = 0.1
var reaction_priority = 0
var element
var can_react
var spell_caster

const CAST_RANGE = 500

# constructs the bullet
func init(skill_dict: Dictionary, cast_target: Vector2, caster: CharacterBody2D):
	# set variables
	abilityID = skill_dict["name"]
	element = skill_dict["element"]
	dmg *= skill_dict["dmg"]
	speed *= skill_dict["speed"]
	lifetime *= skill_dict["lifetime"]
	reaction_priority = skill_dict["priority"]
	spell_caster = caster
	myMovement = Movement.get_movement_object_by_name(skill_dict["movement"])
	mySpawnBehavior = SpawnBehavior.get_spawn_behavior_object_by_name(skill_dict["spawn"])
	setup_spell(cast_target, caster)
	for modifier: Modifier in myModifiers:
		modifier.apply(self)

# set up the spell
func setup_spell(cast_target: Vector2, caster: Node2D):
	add_to_group("skills")
	$LifetimeTimer.wait_time *= lifetime
	$LifetimeTimer.start()
	mySpawnBehavior.apply(self, cast_target)

# run every frame
func _physics_process(delta):
	handle_movement(delta)

# handles movement of bullet. Standard is a constant speed in a straight line.
func handle_movement(delta):
	myMovement.move_to(self, velocity.normalized() * delta * speed)

# on collision
func _on_SpellBody_body_entered(body):
	if body.name != "Player":
		if body.is_in_group("skills"):
			handle_reaction(body)
		elif body.is_in_group("monsters"):
			handle_enemy_interaction(body)
		else:
			handle_other_interaction(body)

# Handles reaction data. MUST BE OVERWRITTEN OR THE SPELL DOES NO REACTION
func handle_reaction(reactant: BaseTypeAbility):
	# Disable own collision with other spells to not react.
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)


# Handles collision when enemy is hit. Spells do not typically despawn.
func handle_enemy_interaction(enemy: Node2D):
	enemy._hit(self.dmg, self.element, self.element, self.spell_caster)

# handles other things like walls
func handle_other_interaction(thing: Node2D):
	pass

# Handles reaction interactions with other spells
func _on_area_entered(area):
	if area.is_in_group("skills"):
		handle_reaction(area)

func _on_LifetimeTimer_timeout():
	despawn()

func despawn():
	self.queue_free()

# Creates a new reaction.
func create_new_reaction(spell_1: Node2D, spell_2: Node2D):
	var reaction_components = get_reaction_source_and_reactant(spell_1, spell_2)
	var reaction_scene = get_reaction_scene(spell_2.element)
	if reaction_scene:
		if reaction_components["reactant"]["name"] == name:
			return
		# set as the child
		reaction_components["source"].add_child(reaction_scene)
		# after entering tree things and if need info from both spells reacting
		reaction_scene.init(reaction_components)

# determine the source and reactant
func get_reaction_source_and_reactant(source: Node2D, reactant: Node2D) -> Dictionary:
	# higher priority means the reaction sticks to it more often
	if source.reaction_priority > reactant.reaction_priority:
		return {"source": source, "reactant": reactant}
	else: 
		return {"source": reactant, "reactant": source}

# FUNCTION TO BE OVERLOADED
func get_reaction_scene(reactant_element: String) -> Node2D:
	print("reaction not implemented!")
	return null
