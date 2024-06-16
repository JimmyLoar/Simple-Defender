class_name Projectile
extends Area2D

signal hitted(enemy: Enemy)
signal dissappeared

@export_range(0.0, 5.0, 0.01, "or_greater") var timelife: float = 3.0
@export var begun_speed := 1280 

@onready var ray_cast = $RayCast2D


func _init():
	pass


func _physics_process(delta: float) -> void:
	var motion = begun_speed * self.transform.x * delta 
	position += motion 
	ray_cast.target_position = motion
	var collider: Enemy = ray_cast.get_collider()
	if not collider: return
	_on_area_entered(collider)


func launch(new_transform: Transform2D):
	transform = new_transform
	visible = true


func _on_area_entered(enemy: Enemy):
	if not enemy.is_death:
		emit_signal("hitted", enemy)
	_dissapear()


func _dissapear():
	dissappeared.emit()

