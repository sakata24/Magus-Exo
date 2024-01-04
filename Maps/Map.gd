extends Node2D

signal edge_reached(edge, location)

func _ready():
	pass

func _on_north_visibility_notifier_screen_entered():
	$NorthVisibilityNotifier.queue_free()
	emit_signal("edge_reached", 'N', global_position)

func _on_south_visibility_notifier_screen_entered():
	$SouthVisibilityNotifier.queue_free()
	emit_signal("edge_reached", 'S', global_position)

func _on_east_visibility_notifier_screen_entered():
	$EastVisibilityNotifier.queue_free()
	emit_signal("edge_reached", 'E', global_position)

func _on_west_visibility_notifier_screen_entered():
	$WestVisibilityNotifier.queue_free()
	emit_signal("edge_reached", 'W', global_position)
	
