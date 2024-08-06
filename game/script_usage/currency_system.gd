class_name CurrencySystem
extends Node

const TEMPLATE = {
	"name": "",
	"translate_key": "",
	"icon": null,
	"value": 0.0,
}

var _data: Dictionary= {} 
var _logger := GodotLogger.with("CorrencySystem")


func create(cname: String, icon: Texture, start_value: float = 0, override := false) -> Dictionary:
	if has(cname) and not override:
		_logger.warn("Can not create '%s' become data exist from this name" % cname)
		return {}
	
	var new_data := Dictionary()
	new_data["name"] = cname.to_lower()
	new_data["translate_key"] = "CORRENCY_NAME_" + cname.to_upper()
	new_data["icon"] = icon
	new_data["value"] = start_value
	_data[cname] = new_data
	_logger.info("Created new corrency %s" % [new_data])
	return new_data


func has(cname: String) -> bool:
	var result = _data.has(cname)
	_logger.debug("Data %s '%s'" % ["HAVE" if result else " HAVE NOT", cname])
	return result


func delete(cname: String) -> bool:
	if not has(cname): 
		return false
	
	_data.erase(cname)
	_logger.debug("Deleted '%s'" % [cname])
	return true


func set_all_values(new_value: float):
	for key in _data.keys():
		_data[key].value = new_value


func get_names():
	return _data.keys()


func get_display_name(cname: String) -> String:
	if not has(cname): 
		return "CORRENCY_NAME_NONE"
	return _data[cname].translate_key


func get_icon(cname: String) -> Texture:
	if not has(cname): 
		return null
	return _data[cname]


func get_value(cname: String) -> float:
	if not has(cname): 
		return 0.0
	return _data[cname].value


func change(cname: String, on_value: float): #add value
	if not has(cname):
		return false
	
	_data[cname] += on_value
	_logger.debug("Changed '%s' on '%0.3f' (%s)" % [cname, on_value, _data[cname]])
	return true


func check_to_value(cname: String, check_value: float):
	if not has(cname):
		return false
	
	return check_value >= _data[cname].value


func pay(cname: String, prise: float):
	if check_to_value(cname, prise):
		change(cname, prise * -1)
