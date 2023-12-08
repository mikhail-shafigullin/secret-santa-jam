extends MiniGame

@onready var c = Global.cutscener
@onready var hit_marker = $TaikoScreen/TaikoLine/Panel/Panel/HitMarker
@onready var hit_marker_col = hit_marker.modulate
@onready var hit_gold = $TaikoScreen/TaikoLine/Panel/Panel/HitGold
@onready var hit_ok = $TaikoScreen/TaikoLine/Panel/Panel/HitOk
@onready var hit_fail = $TaikoScreen/TaikoLine/Panel/Panel/HitFail
var hit_timer = Timer.new()
var model = null

enum HIT_TYPE {
	pon,
	kat
}
enum HIT_EFFECT {
	gold = 0,
	ok,
	fail,
	empty
}

func _ready():
	add_child(hit_timer)
	hit_timer.one_shot = true
	hit_timer.wait_time = 0.16
	hit_timer.connect("timeout", hit_timeout)
	
func _input(event):
	if event.is_action_pressed("taiko_pon"):
		hit(HIT_TYPE.pon)
	if event.is_action_pressed("taiko_kat"):
		hit(HIT_TYPE.kat)
		
func hit(type: HIT_TYPE):
	match type:
		HIT_TYPE.pon:
			model.pon.play()
		HIT_TYPE.kat:
			model.kat.play()
	
	hit_anim()
	
func start() -> bool:
	if not c:
		return false
	
	if (not c.has_animation("taiko_start")
		or not c.has_animation("taiko_rest")):
		return false
	
	Global.player.set_busy(true)
	Global.player.visible = false
	
	return true

func end() -> void:
	c.start("taiko_rest")

	Global.player.visible = true
	Global.player.set_busy(false)
	Global.cutscener.end()
	queue_free()

func _on_exit_pressed():
	end()

func hit_anim(type: HIT_EFFECT=HIT_EFFECT.empty):
	match type:
		HIT_EFFECT.gold:
			hit_gold.visible = true
		HIT_EFFECT.ok:
			hit_ok.visible = true
		HIT_EFFECT.fail:
			hit_fail.visible = true
		_:
			pass
	hit_marker.modulate = Color.WHITE
	hit_timer.start()

func hit_timeout():
	hit_marker.modulate = hit_marker_col
	hit_gold.visible = false
	hit_ok.visible = false
	hit_fail.visible = false
	