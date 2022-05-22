extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var song_name = $Name # CHANGE

export var extension = "mp3";
var global_player = null
var current_length = 0
var internal_name = null
var prepended = Dirtools.current("songs/")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if len(song_name.text) > 50:
		refresh_internal_name()
	
		song_name.text = song_name.text.substr(0, 40) + "..."

func refresh_internal_name():
	internal_name = song_name.text

func when_pressed():
	if internal_name == null:
		print("S")
		refresh_internal_name()
	print(internal_name)
	var title = internal_name
	
	if (global_player != null):
		print(title)
		ListeningProvider.play_song(global_player, prepended + internal_name + "." + extension)
		
