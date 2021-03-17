class Main extends Node {
	var mobScene:PackedScene;
	var spawnLocation:PathFollow;
	var player:Player;

	override function _Ready() {
		mobScene = cast(ResourceLoader.load("res://scenes/mob.tscn"), PackedScene);
		spawnLocation = cast(getNode("SpawnPath/SpawnLocation"), PathFollow);
		player = cast(getNode("Player"), Player);

		final mobTimer = cast(getNode("MobTimer"), Timer);
		mobTimer.connect("timeout", this, "onMobTimer");
		player.onHit.push(() -> mobTimer.stop());
	}

	function onMobTimer() {
		spawnLocation.unitOffset = Math.random();

		final mob = cast(mobScene.instance(), Mob);
		addChild(mob);
		mob.initialize(spawnLocation.translation, player.transform.origin);
	}
}
