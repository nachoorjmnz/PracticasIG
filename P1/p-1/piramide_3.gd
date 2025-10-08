# piramede3.gd
extends Node3D

@export var v_superior: float = 1.0
@export var lado: float = 2.0

var piramede3 := MeshInstance3D.new()
var material := StandardMaterial3D.new()
var modo = load("res://modos_malla.gd")

var vertices: Array = []
var caras: Array = []
var colores: Array = []
var albedo: Color = Color(0.9, 0.4, 0.1, 1.0)

func _ready() -> void:
	vertices = [
		Vector3(-lado * 0.5, 0, -lado * 0.5),
		Vector3( lado * 0.5, 0, -lado * 0.5),
		Vector3(0, 0, lado * 0.5),
		Vector3(0, v_superior, 0)
	]

	caras = [
		[0, 1, 3],
		[1, 2, 3],
		[2, 0, 3],
		[0, 2, 1]
	]

	colores = [
		Color(1.0, 0.0, 0.0, 1.0),
		Color(0.0, 1.0, 0.0, 1.0),
		Color(0.0, 0.0, 1.0, 1.0),
		Color(1.0, 1.0, 0.0, 1.0)
	]

	piramede3.mesh = modo.malla_solido(vertices, caras, colores, material)
	piramede3.material_override = material
	add_child(piramede3)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		match event.keycode:   
			KEY_1:
				var nuevo_material := StandardMaterial3D.new()
				piramede3.mesh = modo.malla_solido(vertices, caras, colores, nuevo_material)
				piramede3.material_override = nuevo_material
			KEY_2:
				var nuevo_material := StandardMaterial3D.new()
				piramede3.mesh = modo.malla_iluminacion(vertices, caras, colores, albedo, nuevo_material)
				piramede3.material_override = nuevo_material
