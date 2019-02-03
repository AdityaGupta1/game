extends "res://scenes/bullet.gd"

func _get_collider():
	for body in area.get_overlapping_bodies():
		if body.get_name() == "player":
			return body;
			
	return null;