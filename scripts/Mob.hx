class Mob extends KinematicBody {
	@:export public var minSpeed = 10;
	@:export public var maxSpeed = 18;

	public var onSquashed:Array<() -> Void> = [];

	var velocity = Vector3.ZERO;

	override function _Ready() {
		getNode("VisibilityNotifier").connect("screen_exited", this, "onScreenExit");
	}

	override function _PhysicsProcess(delta:Single) {
		moveAndSlide(velocity);
	}

	public function initialize(startPositon:Vector3, playerPosition:Vector3) {
		translation = startPositon;
		lookAt(playerPosition, Vector3.UP);
		rotateY(Math.random() * Math.PI / 2 - Math.PI / 4);
		final randomSpeed = Math.random() * (maxSpeed - minSpeed) + minSpeed;
		velocity = Vector3.FORWARD * randomSpeed;
		velocity = velocity.rotated(Vector3.UP, rotation.y);
		cast(getNode("AnimationPlayer"), AnimationPlayer).playbackSpeed = randomSpeed / minSpeed;
	}

	function onScreenExit() {
		queueFree();
	}

	public function squash() {
		for (fn in onSquashed) {
			fn();
		}
		queueFree();
	}
}
