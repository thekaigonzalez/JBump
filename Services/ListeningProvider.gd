# This script provides listening capability for AudioStreamPlayers.
extends Node
func play_song(player: AudioStreamPlayer, fname: String):
	var f = File.new()
	
	print(fname)
	
	f.open(fname, File.READ)
	
	var buffer = f.get_buffer(f.get_len())
	
	if fname.get_extension() == "mp3":
		var stream = AudioStreamMP3.new()
		
		stream.data = buffer
		
		player.stream = stream
		
		SongInfo.SONG_LENGTH = stream.get_length()
	
	var sname = fname.get_file().get_basename()
	
	if len(sname) > 30:
		sname = sname.substr(0, 30) + "..."
		
	SongInfo.Name = sname
	player.play()

func pause(player: AudioStreamPlayer):
	SongInfo.Last_Saved_Time = player.get_playback_position()
	player.stop()
	
func continue(player: AudioStreamPlayer):
	player.play(SongInfo.Last_Saved_Time)
