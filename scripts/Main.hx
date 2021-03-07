class Main extends Node {
	var mobScene:PackedScene;
	var spawnLocation:PathFollow;
	var player:Player;

	final random = new Random(42);

	override function _Ready() {
		mobScene = cast(ResourceLoader.load("res://scenes/mob.tscn"), PackedScene);
		spawnLocation = cast(getNode("SpawnPath/SpawnLocation"), PathFollow);
		player = cast(getNode("Player"), Player);

		getNode("MobTimer").connect("timeout", this, "onMobTimer");
	}

	function onMobTimer() {
		spawnLocation.unitOffset = random.getFloat();

		final mob = cast(mobScene.instance(), Mob);
		mob.initialize(spawnLocation.translation, player.translation);
		addChild(mob);
	}
}
