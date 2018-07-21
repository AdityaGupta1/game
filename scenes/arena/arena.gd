extends Spatial

var enemies = {
	"conke can": preload("res://scenes/enemies/conke can/conke can.tscn"),
	"cube": preload("res://scenes/enemies/cube/cube.tscn"),
	"cosmic crab": preload("res://scenes/enemies/crab/crab.tscn"),
	"milk glass": preload("res://scenes/enemies/milk/milk glass.tscn"),
	"unlimited stick": preload("res://scenes/enemies/stick/stick.tscn")
};
var wave = 0;
# [[healing items], [enemy, spawn chance, spawn tries], [..., ..., ..., ...], ...]
var spawns = [
	[["bepis can"], [enemies["conke can"], 100, 2], [enemies["cube"], 100, 1], [enemies["cosmic crab"], 100, 1]],
	[["bepis can"], [enemies["conke can"], 100, 2], [enemies["cube"], 100, 1, 60, 1], [enemies["cosmic crab"], 100, 1, 60, 1]],
	[["bepis can"], [enemies["conke can"], 100, 1, 50, 1], [enemies["cube"], 100, 2], [enemies["cosmic crab"], 100, 1, 90, 1]],
	[["bepis can", "earth"], [enemies["conke can"], 100, 1], [enemies["cube"], 100, 2], [enemies["cosmic crab"], 100, 2], [enemies["milk glass"], 50, 1]]
];

var spawn_positions = [];

var confirmations = 0;
	
var time = 0;
var start_time = 0;

# randomized to either -1 or 1 each time
var direction = 0;

func start():
	start_time = time + 2;
	
func _physics_process(delta):
	time += delta;
	
	if time > start_time && start_time != 0:
		_spawn_enemies();
		start_time = 0;

func done_extending():
	confirmations += 1;
	
	if confirmations == 8:
		confirmations = 0;
		wave += 1;
		_spawn_enemies();
		
func _spawn_enemies():
	spawn_positions = [];
	
	var enemies = spawns[wave];
	for i in range(1, enemies.size()): # all elements of enemies except the first (healing items)
		var enemy_chances = enemies[i];
		for j in range(1, enemy_chances.size(), 2): # all elements of enemy_chances except the first (enemy name)
			for k in range(enemy_chances[j + 1]): # spawn tries
				if rand_range(0, 100) < enemy_chances[j]: # spawn chance
					var enemy = enemy_chances[0].instance();
					enemy.transform.origin = _find_eligible_spawn_location(enemy.no_spawn_radius);
					get_tree().get_root().get_node("Main").get_node("enemies").add_child(enemy);

func _random_vector(bound):
	return Vector3(rand_range(-bound, bound), rand_range(0, bound), rand_range(-bound, bound));

func spawn_healing_items():
	var healing_items = spawns[wave][0];
	
	if not healing_items: # return if healing_items is empty
		return;
	
	for i in range(5 + (wave * 2)):
		var new_healing_item = load("res://scenes/player/healing/" + healing_items[randi() % healing_items.size()] + ".tscn").instance();
		
		var position = global_transform.origin;
		position.y = 22.5;
		new_healing_item.transform.origin = position;
		
		new_healing_item.apply_impulse(position, _random_vector(4));
		
		new_healing_item.rotation.x = rand_range(0, 2 * PI);
		new_healing_item.rotation.y = rand_range(0, 2 * PI);
		new_healing_item.rotation.z = rand_range(0, 2 * PI);
		
		var spatial = Spatial.new();
		
		get_parent().add_child(spatial);
		spatial.add_child(new_healing_item);

func _generate_random_coordinate():
	return (((randi() % 2) * 2) - 1) * rand_range(6, 16);

func _is_eligible_spawn_location(x, z):
	for position in spawn_positions:
		if Vector2(position[0], position[1]).distance_to(Vector2(x, z)) <= position[2]:
			return false;
			
	return true;

func _find_eligible_spawn_location(no_spawn_radius):
	var x;
	var z;
	
	while true:
		x = _generate_random_coordinate();
		z = _generate_random_coordinate();
		
		if _is_eligible_spawn_location(x, z):
			break;
	
	spawn_positions.append([x, z, no_spawn_radius]);
	return Vector3(x, 22.5, z);
	
func randomize_direction():
	randomize();
	direction = [-1, 1][randi() % 2];