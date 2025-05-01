extends Node2D




func restart():
	for child in get_children():
		if child is spawner:
			child.set_deferred("collision_layer", 0)
			child.set_deferred("collision_mask", 0)

func start():
	for child in get_children():
		if child is spawner:
			child.set_deferred("collision_layer", 1)
			child.set_deferred("collision_mask", 1)
