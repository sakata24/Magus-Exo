extends Node

var userRes = preload("res://User.tres")
var sunderSpriteRes = preload("res://Abilities/Animations/SunderSprite.tres")
var entropySpriteRes = preload("res://Abilities/Animations/EntropySprite.tres")
var constructSpriteRes = preload("res://Abilities/Animations/ConstructSprite.tres")
var growthSpriteRes = preload("res://Abilities/Animations/GrowthSprite.tres")
var flowSpriteRes = preload("res://Abilities/Animations/FlowSprite.tres")
var witherSpriteRes = preload("res://Abilities/Animations/WitherSprite.tres")
var fountainSpriteRes = preload("res://Abilities/Animations/Spells/FountainSprite.tres")
var crackSpriteRes = preload("res://Abilities/Animations/Spells/CrackSprite.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	userRes.construct_xp += 2
	print(userRes.construct_xp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
