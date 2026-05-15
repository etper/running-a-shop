extends Node2D

var time_left = 60

func _on_timer_timeout() -> void:
	time_left -= 1
	print("Time left: " + str(time_left))
	
	if time_left <= 0:
		print("game over")
