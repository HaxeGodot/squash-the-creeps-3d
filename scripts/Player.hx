class Player extends KinematicBody {
	@:export public var speed = 14;
	@:export public var fallAcceleration = 75;
	@:export public var jumpImpulse = 20;
	@:export public var bounceImpulse = 16;

	public var onHit = new CustomSignal<() -> Void>("onHit");

	@:onReadyNode("AnimationPlayer")
	var animationPlayer:AnimationPlayer;

	@:onReadyNode("Pivot")
	var pivot:Spatial;

	var velocity = Vector3.ZERO;

	override function _Ready() {
		getNode("MobDetector").as(Area).onBodyEntered.connect(onMobDetected);
	}

	override function _PhysicsProcess(delta:Single) {
		var direction = Vector3.ZERO;

		if (Input.isActionPressed(MoveRight)) {
			direction.x += 1;
		}
		if (Input.isActionPressed(MoveLeft)) {
			direction.x -= 1;
		}
		if (Input.isActionPressed(MoveBackward)) {
			direction.z += 1;
		}
		if (Input.isActionPressed(MoveForward)) {
			direction.z -= 1;
		}

		if (direction != Vector3.ZERO) {
			direction = direction.normalized();
			pivot.lookAt(translation + direction, Vector3.UP);
			animationPlayer.playbackSpeed = 4;
		} else {
			animationPlayer.playbackSpeed = 1;
		}

		if (isOnFloor() && Input.isActionJustPressed(Jump)) {
			velocity.y += jumpImpulse;
		}

		velocity.x = direction.x * speed;
		velocity.z = direction.z * speed;
		velocity.y -= fallAcceleration * delta;
		velocity = moveAndSlide(velocity, Vector3.UP);

		for (i in 0...getSlideCount()) {
			final collision = getSlideCollision(i);

			if (collision.collider.as(Node).isInGroup("mob")) {
				if (Vector3.UP.dot(collision.normal) > 0.1) {
					collision.collider.as(Mob).squash();
					velocity.y = bounceImpulse;
				}
			}
		}

		pivot.rotation = new Vector3(Math.PI / 6 * velocity.y / jumpImpulse, pivot.rotation.y, pivot.rotation.z);

		// TODO error CS1612: Cannot modify the return value of 'Spatial.Rotation' because it is not a variable
		// pivot.rotation.x = Math.PI / 6 * velocity.y / jumpImpulse;
	}

	function onMobDetected(body:Node) {
		onHit.emitSignal();
		queueFree();
	}
}
