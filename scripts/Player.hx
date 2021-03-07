class Player extends KinematicBody {
	@:export public var speed = 14;
	@:export public var fallAcceleration = 75;

	var velocity = Vector3.ZERO;

	override function _PhysicsProcess(delta:Single) {
		var direction = Vector3.ZERO;

		if (Input.isActionPressed("move_right")) {
			direction.x += 1;
		}
		if (Input.isActionPressed("move_left")) {
			direction.x -= 1;
		}
		if (Input.isActionPressed("move_backward")) {
			direction.z += 1;
		}
		if (Input.isActionPressed("move_forward")) {
			direction.z -= 1;
		}

		if (direction != Vector3.ZERO) {
			direction = direction.normalized();
			cast(getNode("Pivot"), Spatial).lookAt(translation + direction, Vector3.UP);
		}

		velocity.x = direction.x * speed;
		velocity.z = direction.z * speed;
		velocity.y -= fallAcceleration * delta;
		velocity = moveAndSlide(velocity, Vector3.UP);
	}
}
