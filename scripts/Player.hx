class Player extends KinematicBody {
	@:export public var speed = 14;
	@:export public var fallAcceleration = 75;
	@:export public var jumpImpulse = 20;
	@:export public var bounceImpulse = 16;

	public var onHit:Array<() -> Void> = [];

	var animationPlayer:AnimationPlayer;
	var pivot:Spatial;
	var velocity = Vector3.ZERO;

	override function _Ready() {
		animationPlayer = cast(getNode("AnimationPlayer"), AnimationPlayer);
		pivot = cast(getNode("Pivot"), Spatial);
		cast(getNode("MobDetector"), Area).onBodyEntered.connect(onMobDetected);
	}

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
			pivot.lookAt(translation + direction, Vector3.UP);
			animationPlayer.playbackSpeed = 4;
		} else {
			animationPlayer.playbackSpeed = 1;
		}

		if (isOnFloor() && Input.isActionJustPressed("jump")) {
			velocity.y += jumpImpulse;
		}

		velocity.x = direction.x * speed;
		velocity.z = direction.z * speed;
		velocity.y -= fallAcceleration * delta;
		velocity = moveAndSlide(velocity, Vector3.UP);

		for (i in 0...getSlideCount()) {
			final collision = getSlideCollision(i);

			if (cast(collision.collider, Node).isInGroup("mob")) {
				final mob = cast(collision.collider, Mob);

				if (Vector3.UP.dot(collision.normal) > 0.1) {
					mob.squash();
					velocity.y = bounceImpulse;
				}
			}
		}

		pivot.rotation = new Vector3(Math.PI / 6 * velocity.y / jumpImpulse, pivot.rotation.y, pivot.rotation.z);

		// TODO error CS1612: Cannot modify the return value of 'Spatial.Rotation' because it is not a variable
		// pivot.rotation.x = Math.PI / 6 * velocity.y / jumpImpulse;
	}

	function onMobDetected(body:Node) {
		for (fn in onHit) {
			fn();
		}
		queueFree();
	}
}
