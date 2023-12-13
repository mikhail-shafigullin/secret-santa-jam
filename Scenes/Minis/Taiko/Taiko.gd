extends MiniGame

@onready var c = Global.cutscener
@onready var hit_marker = $TaikoScreen/TaikoLine/Panel/Panel/HitMarker
@onready var hit_marker_col = hit_marker.modulate
@onready var hit_gold = $TaikoScreen/TaikoLine/Panel/Panel/HitGold
@onready var hit_ok = $TaikoScreen/TaikoLine/Panel/Panel/HitOk
@onready var hit_fail = $TaikoScreen/TaikoLine/Panel/Panel/HitFail
@onready var combo_lable = %Combo
@onready var max_combo_lable = %MaxCombo
@onready var score_lable = %Score

var hit_timer = Timer.new()
var model = null
var tim = null
var notes: Array[Note] = []
@onready var hit_center: Node2D = %HitCenter
var time: float = 0
@export var visible_time := 3.0
@export var speed := 100.0
@export var time_window = 0.5

var combo: int = 0;
var max_combo: int = 0;
var score: int = 0;

const KatSpriteRes = preload ("res://Scenes/Minis/Taiko/BlueSprite.tscn")
const DonSpriteRes = preload ("res://Scenes/Minis/Taiko/OrangeSprite.tscn")

const debug_music = {1.5: 'K', 1.7: 'D', 1.9: 'K', 2.1: 'K', 2.45: 'K', 2.65: 'D', 2.85: 'K', 3.05: 'K', 3.4: 'K', 3.6: 'D', 3.8: 'K', 4.0: 'K', 4.48: 'K', 4.68: 'D', 4.88: 'K', 5.08: 'K'}
const release_music = {8.06: 'K', 8.55: 'K', 9.05: 'K', 9.56: 'K', 10.06: 'K', 11.62: 'K', 11.84: 'D', 12.06: 'K', 13.6: 'K', 13.82: 'D', 14.04: 'K', 15.61: 'K', 15.83: 'D', 16.05: 'K', 16.49: 'D', 17.05: 'K', 17.55: 'K', 17.8: 'D', 18.05: 'K', 19.33: 'K', 19.58: 'D', 19.83: 'K', 20.08: 'D', 21.58: 'D', 21.83: 'K', 22.08: 'D', 23.57: 'D', 23.82: 'K', 24.07: 'D', 24.57: 'D', 24.82: 'K', 25.07: 'D', 25.57: 'D', 25.82: 'D', 26.07: 'D', 27.57: 'D', 27.82: 'K', 28.07: 'D', 29.56: 'D', 29.81: 'K', 30.06: 'D', 31.56: 'D', 31.81: 'K', 32.06: 'D', 32.49: 'K', 32.84: 'K', 33.08: 'D', 33.49: 'D', 33.83: 'D', 34.11: 'K', 34.59: 'K', 35.09: 'K', 35.59: 'K', 35.84: 'D', 36.09: 'K', 36.59: 'K', 37.09: 'K', 37.59: 'K', 37.84: 'D', 38.09: 'K', 38.59: 'K', 39.09: 'K', 39.59: 'K', 39.84: 'D', 40.09: 'K', 40.59: 'K', 41.09: 'K', 41.59: 'K', 41.84: 'D', 42.09: 'K', 42.59: 'K', 43.34: 'D', 43.59: 'K', 43.84: 'D', 44.59: 'K', 45.09: 'K', 45.59: 'K', 45.84: 'D', 46.09: 'K', 46.59: 'K', 47.59: 'K', 47.84: 'D', 48.09: 'K', 48.59: 'K', 48.84: 'D', 49.09: 'K', 49.56: 'K', 49.76: 'D', 49.96: 'K', 50.16: 'K', 50.59: 'K', 51.09: 'K', 51.59: 'K', 51.84: 'D', 52.09: 'K', 52.59: 'K', 53.09: 'K', 53.6: 'K', 53.84: 'D', 54.07: 'K', 54.57: 'K', 55.07: 'K', 55.57: 'K', 55.82: 'D', 56.07: 'K', 56.46: 'D', 56.66: 'K', 57.36: 'K', 57.61: 'D', 57.86: 'D', 58.11: 'K', 58.57: 'K', 59.07: 'K', 59.57: 'K', 59.82: 'D', 60.07: 'K', 60.55: 'D', 60.95: 'K', 61.82: 'D', 62.07: 'K', 62.32: 'D', 62.57: 'K', 63.07: 'K', 63.57: 'K', 63.83: 'D', 64.09: 'K', 64.46: 'D', 64.66: 'K', 65.07: 'K', 65.59: 'K', 65.82: 'D', 66.05: 'K', 66.46: 'D', 66.66: 'K', 67.07: 'K', 67.32: 'D', 67.57: 'K', 67.82: 'D', 68.07: 'K', 68.45: 'D', 68.65: 'K', 69.07: 'K', 69.57: 'K', 69.82: 'D', 70.07: 'K', 70.45: 'D', 70.65: 'K', 71.07: 'K', 71.57: 'K', 71.82: 'D', 72.07: 'K', 72.57: 'K', 72.82: 'D', 73.07: 'K', 73.57: 'K', 73.77: 'D', 73.97: 'K', 74.17: 'K', 74.5: 'D', 74.7: 'K', 75.07: 'K', 75.57: 'K', 75.82: 'D', 76.07: 'K', 76.46: 'D', 76.66: 'K', 77.07: 'K', 77.57: 'K', 77.82: 'D', 78.07: 'K', 78.47: 'D', 78.67: 'K', 79.07: 'K', 79.57: 'K', 79.82: 'D', 80.07: 'K', 80.45: 'D', 80.65: 'K', 81.07: 'K', 81.27: 'D', 81.47: 'D', 81.67: 'K', 81.87: 'D', 82.07: 'K', 83.87: 'K', 84.07: 'K', 85.45: 'D', 85.66: 'D', 85.87: 'K', 86.08: 'K', 87.84: 'D', 88.07: 'K', 88.57: 'K', 88.82: 'D', 89.07: 'K', 89.33: 'D', 89.57: 'K', 89.79: 'D', 90.01: 'K', 90.45: 'D', 90.67: 'K', 91.06: 'K', 91.56: 'K', 91.81: 'D', 92.06: 'K', 92.44: 'D', 92.64: 'K', 93.06: 'K', 93.56: 'K', 93.81: 'D', 94.06: 'K', 94.44: 'D', 94.64: 'K', 95.06: 'K', 95.56: 'K', 95.81: 'D', 96.06: 'K', 96.45: 'D', 96.65: 'K', 97.06: 'K', 97.46: 'D', 97.66: 'K', 97.86: 'D', 98.06: 'K', 98.45: 'D', 98.65: 'K', 99.07: 'K', 99.32: 'D', 99.56: 'K', 99.81: 'D', 100.06: 'K', 100.45: 'D', 100.65: 'D', 101.06: 'K', 101.56: 'K', 101.83: 'D', 102.1: 'K', 102.46: 'D', 102.66: 'K', 103.06: 'K', 103.56: 'K', 103.81: 'D', 104.06: 'K', 104.56: 'K', 104.81: 'D', 105.06: 'K', 105.56: 'K', 105.91: 'K', 106.11: 'K', 106.86: 'K', 107.86: 'K', 108.06: 'K', 108.86: 'K', 109.43: 'D', 109.65: 'D', 109.86: 'K', 110.07: 'K', 110.5: 'D', 110.84: 'D', 111.06: 'K', 111.28: 'D', 111.5: 'D', 111.84: 'D', 112.06: 'K', 112.54: 'K', 112.8: 'D', 113.06: 'K', 113.45: 'D', 113.81: 'D', 114.06: 'K'}
const music = release_music

var music_spawned: bool = false

enum NoteType {
	KAT,
	DON,
	NONE,
	END
}

class Note:
	var type: NoteType
	var time: float
	var sprite: AnimatedSprite2D
	func _init(_type: NoteType, _time: float, _sprite: AnimatedSprite2D):
		type = _type
		time = _time
		sprite = _sprite

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

var last_index: int = 0
func spawn_next_note():
	if music_spawned:
		return
	var note_time = music.keys()[last_index]
	if (time + visible_time) > note_time:
		#print("spawned ", note_time)
		var type: NoteType
		var sprite: AnimatedSprite2D
		if music[note_time] == "D":
			type = NoteType.DON
			sprite = DonSpriteRes.instantiate()
		else:
			type = NoteType.KAT
			sprite = KatSpriteRes.instantiate()


		hit_center.add_child(sprite)
		sprite.global_position = hit_center.global_position - Vector2(speed*(time - note_time),0)
		notes.append(Note.new(type, note_time, sprite))
		
		last_index += 1
		if last_index >= music.size():
			var end_sprite = AnimatedSprite2D.new()
			hit_center.add_child(end_sprite)
			end_sprite.global_position = hit_center.global_position - Vector2(speed*(time - note_time - time_window*3),0 )
			notes.append(Note.new(NoteType.END, note_time + 3, end_sprite))
			music_spawned = true
		

	
func _process(delta):
	time += delta
	spawn_next_note()
	for note in notes:
		note.sprite.global_position.x -= speed*delta
	
	check_miss()

func check_miss():
	var distance = get_note_dist()
	if distance <= -(time_window / 2) * 0.55 :
		if get_note_type() == NoteType.END:
			end()
		else:
			on_miss()
		
func on_miss(hit: bool = false):
	if notes.is_empty():
		return
	if (notes[0].type == NoteType.END):
		return
	
	var left_note = notes[0]
	if hit:
		left_note.sprite.hit()
	else:
		left_note.sprite.queue_free()
	
	notes.pop_front()
	reset_combo()

func on_hit(type: NoteType):
	var dist = get_note_dist()
	var note_type = get_note_type()

	if note_type == NoteType.END or note_type == NoteType.NONE:
		hit_anim()
		return
	var max = time_window*0.5
	if abs(dist) <= max:
		if type != note_type and get_note_type(1) == type:
			var t1 = get_note_type(1)
			var t1_dist = get_note_dist(1)
			if dist < max and note_type != NoteType.NONE:
				if t1 != NoteType.NONE and t1 != NoteType.END:
					if abs(get_note_dist(1)) < max*0.54:
						if (score_dist(t1_dist) != HIT_EFFECT.fail):
							on_miss()
							on_true_hit()
		else:
			on_true_hit()
	hit_anim()

func on_true_hit():
	var dist = get_note_dist()
	var note_type = get_note_type()
	var score = score_dist(dist)
	
	if note_type == NoteType.END or note_type == NoteType.NONE:
		return

	hit_anim(score)
	if(score == HIT_EFFECT.fail):
		on_miss(true)
	else:
		#print("hit")
		var note = notes.pop_front()
		note.sprite.hit()
		add_combo(score)

func score_dist(dist: float) -> HIT_EFFECT:
	var max = time_window / 2
	if abs(dist) < max * 0.2:
		return HIT_EFFECT.gold
	if abs(dist) < max * 0.55:
		return HIT_EFFECT.ok
	if abs(dist) >= max * 0.55:
		return HIT_EFFECT.fail
	return HIT_EFFECT.empty

func on_kat():
	model.kat.play()
	on_hit(NoteType.KAT)

func on_pon():
	model.pon.play()
	on_hit(NoteType.DON)

func get_note() -> Note:
	if notes.is_empty():
		return Note.new(NoteType.NONE, 9001, null)
	return notes[0] 

func get_note_type(index: int = 0) -> NoteType:
	if notes.size() - 1 < index:
		return NoteType.NONE
	return notes[index].type

func get_note_dist(index: int = 0) -> float:
	if notes.is_empty():
		return 9001.0
	var distance: float = (notes[index].sprite.global_position.x - hit_center.global_position.x)/speed
	return distance
	
func _ready():
	add_child(hit_timer)
	hit_timer.one_shot=true
	hit_timer.wait_time=0.16
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
			on_pon()
			play_blend("LeftDon")
		HIT_TYPE.katL:
			on_kat()
			play_blend("LeftKat")
		HIT_TYPE.ponR:
			on_pon()
			play_blend("RightDon")
		HIT_TYPE.katR:
			on_kat()
			play_blend("RightKat")
		_:
			pass
	
func start() -> bool:
	if not c:
		return false
	
	if (not c.has_animation("taiko_start")
		or not c.has_animation("taiko_rest")):
		return false
	
	Global.player.set_busy(true)
	Global.player.visible=false
	c.start("taiko_start", false)
	tim = model.tim
	
	model.music.play()
	
	tim.show_drum_sticks()
	tim.visible=true
	tim.taiko_tree.active=true

	return true

func end() -> void:
	tim.taiko_tree.active=false
	tim.visible=false
	model.music.stop()
	c.start("taiko_rest", false)

	Global.player.visible=true
	Global.player.set_busy(false)
	Global.cutscener.end()
	queue_free()

func _on_exit_pressed():
	end()

func hit_anim(type: HIT_EFFECT=HIT_EFFECT.empty):
	match type:
		HIT_EFFECT.gold:
			hit_gold.visible=true
		HIT_EFFECT.ok:
			hit_ok.visible=true
		HIT_EFFECT.fail:
			hit_fail.visible=true
		_:
			pass
	hit_marker.modulate=Color.WHITE
	hit_timer.start()

func hit_timeout():
	hit_marker.modulate=hit_marker_col
	hit_gold.visible=false
	hit_ok.visible=false
	hit_fail.visible=false
	
func play_blend(name: String):
	tim.taiko_tree["parameters/%s/request" %name]=AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func reset_combo():
	combo = 0
	combo_lable.text = str(0)

func add_combo(hit_type: HIT_EFFECT):
	combo += 1
	add_score(hit_type)
	combo_lable.text = str(combo)
	if combo > max_combo:
		max_combo = combo
		max_combo_lable.text = str(max_combo)
	
func add_score(hit_type: HIT_EFFECT):
	var base: int = 10
	var scaling: float = 1.0
	match hit_type:
		HIT_EFFECT.ok:
			scaling = 1
		HIT_EFFECT.gold:
			scaling = 1.5
		_:
			scaling = 0.5
	score += (base+combo)*scaling
	score_lable.text = str(score)
