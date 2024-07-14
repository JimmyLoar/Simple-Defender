@tool
extends Node2D


@onready var left: Marker2D = $LEFT
@onready var right: Marker2D = $RIGHT
@onready var down: Marker2D = $DOWN
@onready var up: Marker2D = $UP


func set_connect_position(size: Vector2):
	size += Vector2.ONE * 8
	left.position.x = size.x / -2 
	right.position.x = size.x / 2 
	down.position.y = size.y / 2 
	up.position.y = size.y /  -2 
