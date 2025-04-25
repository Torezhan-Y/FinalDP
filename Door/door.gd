extends Node2D

@export var third_scene : String


func _on_door_animation_body_entered(body: Node2D) -> void:
	if body.name != "player":
		return 
	$OpenDoor.show()

func _on_door_animation_body_exited(body: Node2D) -> void:
	if body.name != "player":
		return 
	$OpenDoor.hide()
	
	


func _on_go_to_next_scene_body_entered(body: Node2D) -> void:
	if body.name != "player":
		return 
	get_tree().change_scene_to_file("res://third_scene.tscn")
