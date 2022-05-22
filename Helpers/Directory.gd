# Dir helpers
extends Node
func current(text):
	return OS.get_executable_path().get_base_dir() + "/" + text
