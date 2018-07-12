extends Spatial

signal retract;

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 20);

	for half in ["Right", "Left"]:
		for side in ["Top", "Right", "Bottom", "Left"]:
				connect("retract", get_node("arena/" + half + "/" + side + "/Platform"), "retract");

var awaiting_player_centered = false;

func _process(delta):
	# for debug purposes only
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene();

	if awaiting_player_centered:
		for body in get_node("arena/Center").get_overlapping_bodies():
				if body.get_name() == "Player":
					emit_signal("retract");
					awaiting_player_centered = false;
					body.lock_movement();

func enemy_died():
	if get_node("enemies").get_children().size() == 1:
		awaiting_player_centered = true;