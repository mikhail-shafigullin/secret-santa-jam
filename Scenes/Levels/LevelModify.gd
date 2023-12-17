class_name LevelModify
extends Node3D

@onready var roofUpgrade1 = $HomeRoofsUpgrade/RoofUpgrade1;
@onready var roofUpgrade2 = $HomeRoofsUpgrade/RoofUpgrade2;
@onready var roofUpgrade3 = $HomeRoofsUpgrade/RoofUpgrade3;
@onready var roofUpgrade4 = $HomeRoofsUpgrade/RoofUpgrade4;
@onready var homeUpgrade = $HomeUpgrade;

var roofUpgrades;

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.levelModify = self;
	roofUpgrades = [roofUpgrade1, roofUpgrade2, roofUpgrade3, roofUpgrade4];
	allHomeDecorationVisible(false);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func visibleRoofUpgrade(index: int, visible: bool):
	roofUpgrades[index].visible = visible;
	for c in get_all_children(roofUpgrades[index]):
		if "disabled" in c:
			c.disabled = !visible

func visibleHomeUpgrade(visible: bool):
	homeUpgrade.visible = visible;
	for c in get_all_children(homeUpgrade):
		if "disabled" in c:
			c.disabled = !visible
	
func allHomeDecorationVisible(visible: bool):
	for elem in roofUpgrades:
		elem.visible = visible;
		for c in get_all_children(elem):
			if "disabled" in c:
				c.disabled = !visible
	visibleHomeUpgrade(visible);

func get_all_children(node) -> Array:
	var children = node.get_children(true)
	for child in children:
		children.append_array(get_all_children(child))
	return children
