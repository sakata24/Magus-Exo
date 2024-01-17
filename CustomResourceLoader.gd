extends Node

var userRes = preload("res://User.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	userRes.construct_xp += 2
	print(userRes.construct_xp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
