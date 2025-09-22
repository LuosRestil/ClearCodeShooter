class_name UI extends CanvasLayer

@onready var laser_label: Label = $LaserCounter/VBoxContainer/Label
@onready var grenade_label: Label = $GrenadeCounter/VBoxContainer/Label
@onready var laser_rect: TextureRect = $LaserCounter/VBoxContainer/TextureRect
@onready var grenade_rect: TextureRect = $GrenadeCounter/VBoxContainer/TextureRect
@onready var progress_bar: ProgressBar = $MarginContainer/ProgressBar

var green: Color = Color("6bbfa3")
var red: Color = Color(0.9, 0, 0, 1)

func _ready():
	Globals.connect("player_stat_update", _on_player_stat_update)
	update_stats()

func update_laser_count():
	laser_label.text = str(Globals.laser_count)
	if (Globals.laser_count > 0):
		laser_rect.set_modulate(green)
	else:
		laser_rect.set_modulate(red)

func update_grenade_count():
	grenade_label.text = str(Globals.grenade_count)
	if (Globals.grenade_count > 0):
		grenade_rect.set_modulate(green)
	else:
		grenade_rect.set_modulate(red)
		
func update_health():
	progress_bar.value = Globals.player_health
	
func _on_player_stat_update():
	update_stats()
	
func update_stats():
	update_laser_count()
	update_grenade_count()
	update_health()
