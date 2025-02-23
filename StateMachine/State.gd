# base state class meant to be inherited
class_name State extends Node

signal Transitioned

func enter():
	pass

func exit():
	pass

func update(delta: float):
	pass

func physics_update(delta: float):
	pass
