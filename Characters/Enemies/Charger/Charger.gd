class_name Charger extends Monster

var lock_target
var dashing = false
var canHit = true
# how long the dash is
var dash_time = 0.5

func _ready():
	attack_range = 70
	super()

func _on_damage_area_body_entered(body):
	if body.name == "Player":
		body.hit(my_dmg)

func _physics_process(delta: float) -> void:
	super(delta)
