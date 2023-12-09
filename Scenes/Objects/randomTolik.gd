extends CharacterBody3D

@onready var anim = $tolik/AnimationPlayer
@onready var mesh: MeshInstance3D = $tolik/Armature/Skeleton3D/Tolik
var timer = Timer.new()
var speed: float = randf_range(0.8, 1.2)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_tolik()
	anim.connect("animation_finished", stop_anim)
	timer.connect("timeout", start_anim)
	timer.one_shot = true
	timer.wait_time = 100
	add_child(timer)

	stop_anim()

func stop_anim(_name: String=""):
	if anim.is_playing():
		anim.stop()
	anim.active = false
	timer.start(randf_range(15, 240))
	anim.process_mode = PROCESS_MODE_DISABLED

func start_anim():
	idle_shot()

func idle_shot() -> void:
	anim.active = true
	anim.process_mode = PROCESS_MODE_INHERIT
	anim.play("idle%d" %randi_range(1, 9))

func randomize_tolik() -> void:
	anim.speed_scale = speed
	mesh.set("blend_shapes/fat", randf_range(-0.05, 1))
	mesh.set("blend_shapes/female", randi_range(0, 1))
	
	var mat: Material = mesh.get_active_material(0)
	var new_mat = mat.duplicate()
	new_mat.set("shader_parameter/texture_albedo", load("res://Assets/Models/Characters/Tolik/texture/tolik%d.png"%randi_range(1,7)))
	new_mat.set("shader_parameter/breath", randf_range(0.03, 0.05))
	mesh.material_override = new_mat
	
