# Bosses take 1/3 of burn damage
# Burn will tick for 2% current HP

class_name BurnStatusEffect extends StatusEffect

func _on_tick_timer_timeout() -> void:
	var dmg_value = 1 + (parent.health/50)
	if parent is Boss:
		dmg_value = dmg_value/3
	var dmg = DamageObject.new(dmg_value, ["sunder", "growth"], caster)
	parent._hit(dmg)
