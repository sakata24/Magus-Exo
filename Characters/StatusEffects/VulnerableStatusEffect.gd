# amplify any damage taken

class_name VulnerableStatusEffect extends StatusEffect

@onready var debuff_target: Enemy = get_parent()

func _ready() -> void:
	debuff_target.connect("got_hit", amplify_dmg)

func _on_timeout_timer_timeout() -> void:
	self.queue_free()

func amplify_dmg(damage_obj: DamageObject):
	damage_obj.value *= 1.2

func set_debuff_length(new_time: float):
	$TimeoutTimer.wait_time = new_time

func restart_debuff_timer():
	$TimeoutTimer.start()
