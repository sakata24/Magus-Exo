# to multicast a spell
class_name MulticastModifier extends Modifier

var multicast_count: int
var multicast_timer: Timer = Timer.new()
var multicast_array = []

func apply(spell: BaseTypeAbility):
	for i in multicast_count:
		multicast_array.append(spell.duplicate())
	multicast_timer.start()
