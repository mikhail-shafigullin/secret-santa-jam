extends MiniGame

@onready var c = Global.cutscener

func start() -> bool:
	if not c:
		return false
	
	if (not c.has_animation("taiko_start")
		or not c.has_animation("taiko_rest") ):
		return false
	
	Global.player.set_busy(true)
	

	return true

func end() -> void:
	c.start("taiko_rest")

	Global.player.set_busy(false)
	Global.cutscener.end()
	queue_free()

func _on_exit_pressed():
	end()
