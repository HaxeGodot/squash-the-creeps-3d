class Main extends Node {
	var mobScene:PackedScene;

	@:onReadyNode("UserInterface/ScoreLabel")
	var score:Score;

	@:onReadyNode("SpawnPath/SpawnLocation")
	var spawnLocation:PathFollow;

	@:onReadyNode("Player")
	var player:Player;

	@:onReadyNode("UserInterface/Retry")
	var retry:ColorRect;

	override function _Ready() {
		mobScene = cast(ResourceLoader.load("res://scenes/mob.tscn"), PackedScene);

		final mobTimer = cast(getNode("MobTimer"), Timer);
		mobTimer.onTimeout.connect(onMobTimer);
		player.onHit.connect(() -> {
			mobTimer.stop();
			retry.show();
		});

		retry.hide();
	}

	function onMobTimer() {
		spawnLocation.unitOffset = Math.random();

		final mob = cast(mobScene.instance(), Mob);
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
