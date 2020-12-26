extends Node2D


func disappear():
	$AnimationPlayer.play("disappear");


func appear():
	$AnimationPlayer.play_backwards("disappear");
