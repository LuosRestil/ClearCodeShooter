extends CanvasLayer

signal player_stat_update

var laser_count: int = 20:
	set(val):
		laser_count = val
		player_stat_update.emit()
		
var grenade_count: int = 10:
	set(val):
		grenade_count = val
		player_stat_update.emit()
		
var player_max_health: int = 100
var player_health = 50:
	set(val):
		player_health = min(player_max_health, val)
		player_stat_update.emit()
