extends Spatial

var shoot_delay = 0.5;
var rotation_time = (0.8 * shoot_delay)
var a = 2.2475 / rotation_time;

var total_time = rotation_time;

var bullet = preload("res://scenes/player/bullet.tscn");

func get_shoot_delay():
	return shoot_delay;

func shoot():
	var new_bullet = bullet.instance();
	new_bullet.transform.origin = get_node("barrel").global_transform.origin;
	new_bullet.rotation.y = get_tree().get_root().get_node("Main").get_node("Player").rotation.y;
	get_tree().get_root().get_node("Main").add_child(new_bullet);
	total_time = 0;
	
	get_node("sound").play(0);
	
	pass;

func _get_rotation(x):
	return max((50 / 2.1564) * (-pow((a * x) - pow(3, 1/4), 4) + 3 - (a * x)), 0);

func _physics_process(delta):
	if total_time < rotation_time: 
		total_time += delta;
	else:
		get_node("sound").stop();
	
	rotation.z = deg2rad(_get_rotation(total_time));
	
	pass;
