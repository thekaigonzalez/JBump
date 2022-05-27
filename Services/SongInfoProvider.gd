extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var Name = "Song Name"
export var Author = "Unknown Artist"
export var SONG_LENGTH = 0
export var Last_Saved_Time = 0


func get_file_time(fname):
	print(fname.get_extension())
	if fname.get_extension() == "mp3":
		var st = AudioStreamMP3.new()
		var f = File.new()
		f.open(fname, File.READ)
		var b = f.get_buffer(f.get_len())

		st.data = b

		return st.get_length()
