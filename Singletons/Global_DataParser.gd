extends Control

var file:File

func load_data(url) -> Dictionary:
	var data:Dictionary = {}
	var opened

	file = File.new()

	if url == null: 
		return {}

	opened = file.open(url, File.READ)
	assert(opened == 0, "Error al abrir el archivo") # Asegurarnos que puede abrir el archivo
	data = parse_json(file.get_as_text())
	file.close()
	
	return data

#func write_data(url:String, dict:Dictionary) -> void:
#	if url == null: return
#	file.open(url, File.WRITE)
#	file.store_line(to_json(dict))
#	file.close()
