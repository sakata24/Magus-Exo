# Enemy represents a target that is able to recieve damage from the player
class_name Enemy extends CharacterBody2D

var damageNumber = preload("res://HUDs/DamageNumber.tscn")

# how fast i move
var speed = 0
# base speed for ref
var baseSpeed = 0
# my health
@export var health = 1
# max health
var maxHealth = 1
# last damage hit with
var lastElementsHitBy = []
# cc immune?
var cc_immune: bool = false

func hit(damage: DamageObject):
	# reduce my hp
	health -= damage.get_value()
	# set the element to give player xp for
	if damage.get_types()[0] == damage.get_types()[1]:
		lastElementsHitBy = [damage.get_type(0)]
	else:
		lastElementsHitBy = [damage.get_type(0), damage.get_type(1)]
	var dmgNum = damageNumber.instantiate()
	dmgNum.set_colors(AbilityColor.get_color_by_string(damage.get_type(0)), AbilityColor.get_color_by_string(damage.get_type(1)))
	get_parent().add_child(dmgNum)
	dmgNum.set_value_and_pos(damage.get_value(), self.global_position)
