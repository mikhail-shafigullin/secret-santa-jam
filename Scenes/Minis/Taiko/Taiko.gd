extends MiniGame

@onready var c = Global.cutscener
@onready var hit_marker = $TaikoScreen/TaikoLine/Panel/Panel/HitMarker
@onready var hit_marker_col = hit_marker.modulate
@onready var hit_gold = $TaikoScreen/TaikoLine/Panel/Panel/HitGold
@onready var hit_ok = $TaikoScreen/TaikoLine/Panel/Panel/HitOk
@onready var hit_fail = $TaikoScreen/TaikoLine/Panel/Panel/HitFail
@onready var combo_lable = %Combo
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

var combo: int;
var max_combo: int;
var score: int;

const KatSpriteRes = preload ("res://Scenes/Minis/Taiko/BlueSprite.tscn")
const DonSpriteRes = preload ("res://Scenes/Minis/Taiko/OrangeSprite.tscn")

const music = {2.7: 'D', 3.73: 'K', 4.28: 'K'}

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
		if last_index >= music.size()-1:
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
	if distance <= -time_window/2:
		if get_note_type() == NoteType.END:
			end()
		else:
			on_miss()
		
func on_miss(hit: bool = false):
	if notes.is_empty():
		return
	var left_note = notes[0]
	if hit:
		left_note.sprite.hit()
	else:
		left_note.sprite.queue_free()
		
	notes.remove_at(0)
	reset_combo()

func on_hit(type: NoteType):
	var dist = get_note_dist()
	var note_type = get_note_type()

	if note_type == NoteType.END:
		hit_anim()
		return
	if abs(dist) < time_window/2:
		if type != note_type:
			if dist > time_window/2 - time_window * 0.5:
				on_miss();
		else:
			var score = score_dist(dist)
			hit_anim(score)
			if(score == HIT_EFFECT.fail):
				on_miss(true)
			else:
				#print("hit")
				notes[0].sprite.hit()
				add_combo(score)
				notes.remove_at(0)
	hit_anim()
			
func score_dist(dist: float) -> HIT_EFFECT:
	var max = time_window / 2
	if abs(dist) < max * 0.2:
		return HIT_EFFECT.gold
	if abs(dist) > max * 0.75:
		return HIT_EFFECT.ok
	if abs(dist) > max * 0.9:
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

func get_note_type() -> NoteType:
	if notes.is_empty():
		return NoteType.NONE
	return notes[0].type

func get_note_dist() -> float:
	if notes.is_empty():
		return 9001.0
	var distance: float = (notes[0].sprite.global_position.x - hit_center.global_position.x)/speed
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
	
func add_score(hit_type: HIT_EFFECT):
	score += 10*combo
	score_lable.text = str(score)
