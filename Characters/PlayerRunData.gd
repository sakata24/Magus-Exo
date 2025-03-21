class_name PlayerRunData extends Resource

@export var sunder_dmg_boost = 1.0
@export var sunder_extra_casts = 1

@export var entropy_speed_boost = 1.0
@export var entropy_crit_chance = 0.0

@export var construct_size_boost = 1.0
@export var construct_ignore_walls = true

@export var growth_lifetime_boost = 1.0
@export var growth_reaction_potency = 1.0

@export var flow_cooldown_reduction = 1.0
@export var flow_size_boost = 1.0

@export var wither_lifetime_boost = 1.0
@export var wither_size_boost = 1.0

func apply_run_buffs(ability: BaseTypeAbility):
	match ability.element:
		"sunder":
			ability.dmg = floor(ability.dmg * sunder_dmg_boost)
		"entropy":
			ability.speed *= entropy_speed_boost
			if randf_range(0, 1) < entropy_crit_chance:
				ability.dmg = floor(ability.dmg * 1.75)
		"construct":
			ability.scale *= construct_size_boost
		"growth":
			ability.lifetime *= growth_lifetime_boost
			ability.get_node("LifetimeTimer").wait_time *= growth_lifetime_boost
		"flow":
			ability.scale *= flow_size_boost
		"wither":
			ability.lifetime *= wither_lifetime_boost
			ability.get_node("LifetimeTimer").wait_time *= wither_lifetime_boost
			ability.scale *= construct_size_boost
