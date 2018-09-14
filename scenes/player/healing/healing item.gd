extends RigidBody

var health_restored = {
	"bepis can": 15,
	"earth": 25,
	"corb": 30
};

func _ready():
	set_collision_layer(0);
	set_collision_mask(33); # player and enemies
	
func _on_body_entered(body):
	if body.get_name() == "Player":
		get_tree().get_root().get_node("Main").get_node("Player").heal(health_restored[self.get_name()]);
		queue_free();
	
func _physics_process(delta):
	if global_transform.origin.y < 0:
		get_parent().queue_free(); # because each healing item is encased in a Spatial to preserve its name