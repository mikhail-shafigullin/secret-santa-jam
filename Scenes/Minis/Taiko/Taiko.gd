extends MiniGame

@onready var c = Global.cutscener
@onready var hit_marker = $TaikoScreen/TaikoLine/Panel/Panel/HitMarker
@onready var hit_marker_col = hit_marker.modulate
@onready var hit_gold = $TaikoScreen/TaikoLine/Panel/Panel/HitGold
@onready var hit_ok = $TaikoScreen/TaikoLine/Panel/Panel/HitOk
@onready var hit_fail = $TaikoScreen/TaikoLine/Panel/Panel/HitFail
var hit_timer = Timer.new()
var model = null
var tim = null

enum HIT_TYPE {
	ponL,
	katL,
	ponR,
	katR
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
	if event.is_action_pressed("taiko_pon_left"):
		hit(HIT_TYPE.ponL)
	if event.is_action_pressed("taiko_kat_left"):
		hit(HIT_TYPE.katL)
	if event.is_action_pressed("taiko_pon_right"):
		hit(HIT_TYPE.ponR)
	if event.is_action_pressed("taiko_kat_right"):
		hit(HIT_TYPE.katR)
		
func hit(type: HIT_TYPE):
	match type:
		HIT_TYPE.ponL:
			model.pon.play()
			play_blend("LeftDon")
		HIT_TYPE.katL:
			model.kat.play()
			play_blend("LeftKat")
		HIT_TYPE.ponR:
			model.pon.play()
			play_blend("RightDon")
		HIT_TYPE.katR:
			model.kat.play()
			play_blend("RightKat")
	
	hit_anim()
	
func start() -> bool:
	if not c:
		return false
	
	if (not c.has_animation("taiko_start")
		or not c.has_animation("taiko_rest")):
		return false
	
	Global.player.set_busy(true)
	Global.player.visible = false
	c.start("taiko_start", false)
	tim = model.tim

	tim.visible = true
	tim.taiko_tree.active = true

	return true

func end() -> void:
	tim.taiko_tree.active = false
	tim.visible = false
	c.start("taiko_rest", false)

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
	
func play_blend(name: String):
	tim.taiko_tree["parameters/%s/request" %name]= AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
