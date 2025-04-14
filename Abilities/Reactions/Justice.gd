class_name JusticeReaction extends AreaReaction

var parents
var self_ready = false

func _ready() -> void:
	self_ready = true

func init(reaction_components: Dictionary):
	parents = reaction_components
	spawn_reaction_name("justice!", get_parent(), Color("#82b1ff"), Color("#591b82"))
	# reparent myself to main to not despawn when parents react and destroy themselves
	reparent(parents["source"].get_parent(), true)
	self.global_rotation = 0.0

func _physics_process(delta: float) -> void:
	if self_ready:
		repel_all_in_area()
		set_collision_mask_value(2, false)
		$Sprite2D.material.set("shader_parameter/flashState", $Sprite2D.material.get("shader_parameter/flashState") + 0.05)
	if $Sprite2D.material.get("shader_parameter/flashState") >= 1:
		queue_free()

func repel_all_in_area():
	for target in get_overlapping_bodies():
		if target.is_in_group("monsters") and (not target.cc_immune):
			target.can_move = false
			target.velocity = self.global_position.direction_to(target.global_position) * 300
			attach_stun_timer(0.3, target)

# create a timer and add to unstun the enemy
func attach_stun_timer(wait_time: float, enemy: Node2D):
	var timer = Timer.new()
	timer.wait_time = wait_time
	# add the function to be run on timeout
	timer.connect("timeout", func():
		if enemy is Monster:
			enemy.can_move = true
		enemy.velocity = Vector2.ZERO
		timer.queue_free())
	enemy.add_sibling(timer)
	timer.start()
