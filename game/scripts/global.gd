extends Node
const MAX_STAGE = 100
var highest_score = 0

func _ready():
	print("ready")
	load_game()

func change_highest_score(score):
	highest_score = score
	save_game()
	

# Збереження гри
func save_game():
	var savegame = File.new()
	savegame.open("user://stones_savegame.save", File.WRITE)
	savegame.store_line({str(0):highest_score}.to_json())
#	savegame.store_line({str(1):highest_score}.to_json())
	savegame.close()
#
# Завантаження гри
func load_game():
	var savegame = File.new()
	if !savegame.file_exists("user://stones_savegame.save"):
		return #Error!  We don't have a save to lo
	var currentline = {} 
	savegame.open("user://stones_savegame.save", File.READ)
	var n = 0
	while (!savegame.eof_reached()):
		n += 1
		currentline.parse_json(savegame.get_line())
	savegame.close()
	highest_score = currentline["0"]
