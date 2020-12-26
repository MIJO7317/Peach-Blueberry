extends Spatial


func disappear():
	$AnimationPlayer.play("disappear");


func appear():
	$AnimationPlayer.play_backwards("disappear");
