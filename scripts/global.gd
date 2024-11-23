extends Node

var build_mode = false
var placing = false
var pause = false

var block_id 
var blocks_id = []

var collected_blocks1 = 0
var collected_blocks2 = 0

var collected_fishes = 0

var is_key_collected = false

var switch_state = false

var note_to_open = false
var showNote = false

#func _process(delta: float) -> void:
#	Engine.time_scale = 0.2
