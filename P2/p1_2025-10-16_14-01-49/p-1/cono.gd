extends Node3D

@export var altura: float = 1.0
@export var radio: float = 0.5
@export var lados: int = 10

var cono = MeshInstance3D.new()
var material = StandardMaterial3D.new()
var mesh = ArrayMesh.new()
var modos = load("res://modos_malla.gd") 
var vértices = []
var caras = []
var colores = []
var colores_vertices = []
var albedo = Color(0.9, 0.4, 0.1, 1.0)

func _ready() -> void:
	# Vértices de la base circular
	for j in range(lados):
		var px = radio * cos(j * 2 * PI / lados)
		var pz = -radio * sin(j * 2 * PI / lados)
		vértices.append(Vector3(px, 0, pz))
	# Vértice superior
	vértices.append(Vector3(0, altura, 0))
	# Centro base
	vértices.append(Vector3(0, 0, 0))

	# Caras laterales
	for k in range(lados):
		var siguiente = (k + 1) % lados
		caras.append([k, lados, siguiente])
	# Caras de la base
	for m in range(lados):
		var siguiente = (m + 1) % lados
		caras.append([lados + 1, m, siguiente])

	# Colores aleatorios por cara
	for n in range(caras.size()):
		colores.append(Color(randf(), randf(), randf()))
	# Colores aleatorios por vértice
	for v in range(vértices.size()):
		colores_vertices.append(Color(randf(), randf(), randf()))

	# Visualización iluminación suave
	mesh = modos.malla_iluminacion_suave(vértices, caras, colores, albedo, material)
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	cono.mesh = mesh
	cono.material_override = material
	add_child(cono)

	print("Cono creado con ", vértices.size(), " vértices y ", caras.size(), " caras")
	print("Controles: 1=Sólido, 2=Iluminación básica, 3=Iluminación normal, 4=Iluminación suave, 5=Invisible, 6=Iluminación plana, 7=Color por vértice")

func _input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				cambiar_modo("solido")
			KEY_2:
				cambiar_modo("iluminacion")
			KEY_3:
				cambiar_modo("iluminacion_normal")
			KEY_4:
				cambiar_modo("iluminacion_suave")
			KEY_5:
				cambiar_modo("invisible")
			KEY_6:
				cambiar_modo("iluminacion_plana")
			KEY_7:
				cambiar_modo("color_por_vertice")

func cambiar_modo(modo_nombre: String):
	match modo_nombre:
		"solido":
			mesh = modos.malla_solido(vértices, caras, colores, material)
			print("Modo: Sólido (colores aleatorios)")
		"iluminacion":
			mesh = modos.malla_iluminacion(vértices, caras, colores, albedo, material)
			print("Modo: Iluminación básica")
		"iluminacion_normal":
			mesh = modos.malla_iluminacion_normal(vértices, caras, colores, albedo, material)
			print("Modo: Iluminación normal")
		"iluminacion_suave":
			mesh = modos.malla_iluminacion_suave(vértices, caras, colores, albedo, material)
			print("Modo: Iluminación suave")
		"iluminacion_plana":
			mesh = modos.malla_iluminacion_plana(vértices, caras, colores, albedo, material)
			print("Modo: Iluminación plana (flat shading)")
		"invisible":
			mesh = modos.malla_invisible(vértices, caras, colores, material)
			print("Modo: Invisible")
		"color_por_vertice":
			mesh = modos.malla_color_por_vertice(vértices, caras, colores_vertices, material)
			print("Modo: Color por vértice")
	cono.mesh = mesh
