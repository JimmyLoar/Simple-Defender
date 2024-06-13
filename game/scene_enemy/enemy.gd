class_name Enemy
extends Area2D

signal dead(enemy: Enemy)

@export var move_speed := 64


func death():
	emit_signal("dead", self)
