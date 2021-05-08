class Main extends Node {
	@:onready var mobScene = ResourceLoader.load("res://scenes/mob.tscn").as(PackedScene);
	@:onready var score = getNode("UserInterface/ScoreLabel").as(Score);
	@:onready var spawnLocation = getNode("SpawnPath/SpawnLocation").as(PathFollow);
	@:onready var player = getNode("Player").as(Player);
	@:onready var retry = getNode("UserInterface/Retry").as(ColorRect);

	override function _Ready() {
		final mobTimer = getNode("MobTimer").as(Timer);
		mobTimer.onTimeout.connect(onMobTimer);
		player.onHit.connect(() -> {
			mobTimer.stop();
			retry.show();
		});

		retry.hide();
	}

	function onMobTimer() {
		spawnLocation.unitOffset = Math.random();

		final mob = mobScene.instance().as(Mob);
		addChild(mob);
		mob.initialize(spawnLocation.translation, player.transform.origin);
		mob.onSquashed.connect(score.onMobSquashed);
	}

	override function _UnhandledInput(event:InputEvent) {
		if (event.isActionPressed("ui_accept") && retry.visible) {
			getTree().reloadCurrentScene();
		}
	}
}
