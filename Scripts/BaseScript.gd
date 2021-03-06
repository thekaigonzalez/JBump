extends Control

onready var song_list = $OpenList/SongContainer/SongList
onready var strm = $"Stream"
onready var dock = $"SongDock"

export var LOOP_ENABLED = false
export var Use_SongDataBase = false

var songDB = {}


func listdir(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files


func add_song(name, author, length):
	var instance = load("res://Components/Song.tscn").instance()
	instance.get_node("Name").text = name
	instance.get_node("Author").text = author
	instance.get_node("Length").text = length
	instance.global_player = strm
	song_list.add_child(instance)


func add_song_prepended(name, author, length, pref):
	var instance = load("res://Components/Song.tscn").instance()
	instance.get_node("Name").text = name
	instance.get_node("Author").text = author
	instance.get_node("Length").text = length
	instance.prepended = pref
	instance.global_player = strm
	song_list.add_child(instance)


func parse_timer(time):
	var seconds = fmod(time, 60)
	var minutes = fmod(time, 3600) / 60

	var secsx = ""
	if seconds < 10:
		secsx += "0"
	secsx += str(int(seconds))

	var t = ""

	t = str(int(minutes)) + ":" + secsx
	return t


func addSongs(dirname, _use_custom_prepend = false):
	for song in listdir(dirname):
		print(song)
		if song.get_extension() == "mp3":
			var sname = song.get_basename()
			var art = "Unknown Artist"

			if sname in songDB:
				art = songDB[sname]
			add_song(sname, art, parse_timer(SongInfo.get_file_time(dirname + "/" + song)))


func CaddSongs(dirname):
	for song in listdir(dirname):
		print(song)
		if song.get_extension() == "mp3":
			var sname = song.get_basename()
			var art = "Unknown Artist"
			if sname in songDB:
				art = songDB[sname]
				print("AUTHOR FOUND")
			add_song_prepended(
				sname, art, parse_timer(SongInfo.get_file_time(dirname + "/" + song)), dirname + "/"
			)


func _ready():
	if Use_SongDataBase:
		print("Gathering .songdb..")
		if File.new().file_exists(Dirtools.current(".songdb")):
			print("Found songDB")
			print("Loading songDB")
			var songdb = File.new()
			songdb.open(Dirtools.current(".songdb"), File.READ)
			var songdbfd = JSON.parse(songdb.get_as_text()).result
			var final_sdb = {}
			for s in songdbfd:
				if (typeof(songdbfd[s]) == TYPE_ARRAY):
					for song in songdbfd[s]:
						final_sdb[song] = s
				else:
					final_sdb[s] = songdbfd[s]
			songDB = final_sdb
			print("SDB: " + str(songDB))
			songdb.close()

	addSongs(Dirtools.current("songs/"))

	# Optionally, load ~/Music directory
	var dir = Directory.new()
	var pathT = OS.get_environment("HOME") + "/Music"
	print(pathT)
	if dir.dir_exists(pathT):
		print("Music exists")
		CaddSongs(pathT)
	print("Hello!")


func _process(_delta):
	
	$Stream.volume_db = $SongDock/Volume.value
	# set the progress bar values to the current song position
	dock.get_node("Progress").max_value = SongInfo.SONG_LENGTH
	dock.get_node("Progress").value = strm.get_playback_position()

	# if the dock hasn't been moved yet
	if strm.is_playing() and dock.rect_position.y == 727:
		dock.get_node("Anims").play("PostUp")
	# if playback is songlength (song has ended) then replay
	if strm.get_playback_position() == SongInfo.SONG_LENGTH and LOOP_ENABLED:
		strm.seek(0)
		strm.play()

	# Grab the song name
	var snm = SongInfo.Name

	if strm.is_playing():
		var igt = load("res://Assets/Pause.png")
		$SongDock/Playmusic.texture_normal = igt
	else:
		var igt = load("res://Assets/Play.png")
		$SongDock/Playmusic.texture_normal = igt
	# Parse the name
	if len(snm) > 10:
		snm = (snm.substr(0, 10) + "..")
	dock.get_node("Name").text = snm
	dock.get_node("Artist").text = SongInfo.Author


func _on_Playmusic_pressed():
	# Toggle
	if strm.is_playing():
		ListeningProvider.pause(strm)
	else:
		ListeningProvider.continue(strm)


func _on_Loop_pressed():
	if LOOP_ENABLED:
		LOOP_ENABLED = false
		$SongDock/LL.text = "Loop disabled."

	else:
		LOOP_ENABLED = true
		$SongDock/LL.text = "Loop enabled."
	$SongDock/LL/LoopAnim.play("Loop")
