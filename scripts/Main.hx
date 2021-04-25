class Main extends Node {
	var mobScene:PackedScene;
	var score:Score;
	var spawnLocation:PathFollow;
	var player:Player;
	var retry:ColorRect;

	override function _Ready() {
		mobScene = cast(ResourceLoader.load("res://scenes/mob.tscn"), PackedScene);
		score = cast(getNode("UserInterface/ScoreLabel"), Score);
		spawnLocation = cast(getNode("SpawnPath/SpawnLocation"), PathFollow);
		player = cast(getNode("Player"), Player);
		retry = cast(getNode("UserInterface/Retry"), ColorRect);

		final mobTimer = cast(getNode("MobTimer"), Timer);
		mobTimer.onTimeout.connect(onMobTimer);
		player.onHit.push(() -> {
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
		mob.onSquashed.push(score.onMobSquashed);
	}

	override function _UnhandledInput(event:InputEvent) {
		if (event.isActionPressed("ui_accept") && retry.visible) {
			getTree().reloadCurrentScene();
		}
	}
}
