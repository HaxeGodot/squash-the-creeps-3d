class Score extends Label {
	var score = 0;

	public function onMobSquashed() {
		score++;
		text = 'Score $score';
	}
}
