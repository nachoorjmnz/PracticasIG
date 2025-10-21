extends Node3D

@export var altura: float = 0.8
@export var base_size: float = 0.5 

var mesh_instance : MeshInstance3D
var material = StandardMaterial3D.new()
var modos = load("res://modos_malla.gd")

var vértices: PackedVector3Array = []
var caras: Array = []
var colores: PackedColorArray = []
var colores_vertices: PackedColorArray = []
var albedo: Color = Color(0.639, 0.518, 0.421, 1.0) 

func _ready():
	mesh_instance = MeshInstance3D.new()
	
	var p1 = Vector3(-base_size, 0, -base_size)
	var p2 = Vector3(base_size, 0, -base_size)
	var p3 = Vector3(base_size, 0, base_size) 
	var p4 = Vector3(-base_size, 0, base_size)
	var apex = Vector3(0, altura, 0)          
	
	vértices.append_array([p1, p2, p3, p4, apex])

	caras.append([0, 1, 4])
	caras.append([1, 2, 4])
	caras.append([2, 3, 4])
	caras.append([3, 0, 4])
	
	caras.append([0, 3, 2])
	caras.append([0, 2, 1])

	for i in range(caras.size()):
		colores.append(Color(randf(), randf(), randf()))
		
	for i in range(vértices.size()):
		colores_vertices.append(Color(randf(), randf(), randf()))

	var initial_mesh = modos.malla_iluminacion_suave(vértices, caras, colores, albedo, material)
	
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	mesh_instance.mesh = initial_mesh
	mesh_instance.material_override = material
	add_child(mesh_instance)
	
	position.y = 0.5
	
	print("Pirámide creada con ", vértices.size(), " vértices y ", caras.size(), " caras")
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
			mesh_instance.mesh = modos.malla_solido(vértices, caras, colores, material)
			print("Modo: Sólido (colores aleatorios)")
		"iluminacion":
			mesh_instance.mesh = modos.malla_iluminacion(vértices, caras, colores, albedo, material)
			print("Modo: Iluminación básica")
		"iluminacion_normal":
			mesh_instance.mesh = modos.malla_iluminacion_normal(vértices, caras, colores, albedo, material)
			print("Modo: Iluminación normal")
		"iluminacion_suave":
			mesh_instance.mesh = modos.malla_iluminacion_suave(vértices, caras, colores, albedo, material)
			print("Modo: Iluminación suave")
		"iluminacion_plana":
			mesh_instance.mesh = modos.malla_iluminacion_plana(vértices, caras, colores, albedo, material)
			print("Modo: Iluminación plana (flat shading)")
		"invisible":
			mesh_instance.mesh = modos.malla_invisible(vértices, caras, colores, material)
			print("Modo: Invisible")
		"color_por_vertice":
			mesh_instance.mesh = modos.malla_color_por_vertice(vértices, caras, colores_vertices, material)
			print("Modo: Color por vértice")

	mesh_instance.material_override = material
