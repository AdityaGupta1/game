extends KinematicBody

var time_existed = 0;
var lifespan;
var speed;
var damage;

func _physics_process(delta):
	time_existed += delta;
	
	if time_existed > lifespan:
		queue_free();
		
	var collision = move_and_collide(Vector3(cos(rotation.y), 0, -sin(rotation.y)) * speed / 1000);
	
	if collision:
		var hit = collision.get_collider();
		if should_collide(hit):
			hit.damage(damage);
			queue_free();
		
	pass

func should_collide(hit):
	pass;