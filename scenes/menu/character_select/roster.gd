class_name Roster extends Resource

@export var fighters: Array[FighterConfig]

func _iter_init(iter: Array) -> bool:
	iter[0] = 0
	return fighters.size() != 0

func _iter_get(iter: Variant) -> Variant:
	return fighters[iter]

func _iter_next(iter: Array) -> bool:
	iter[0] += 1
	return fighters.size() > iter[0]
