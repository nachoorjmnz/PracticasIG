extends Node3D  # se crea en un node_3D
@export var altura: float = 1.0
@export var radio: float = 0.5
@export var lados: int = 10
# variables globales al script
var cono = MeshInstance3D.new()
var material = StandardMaterial3D.new()
var mesh = ArrayMesh.new()
var modo = load("res://modos_malla.gd")
# matrices de vértices y caras inicialmente vacías
var vértices = [ ] 
# caras
var caras = [ ]
# colores
var colores = [ ]
var albedo = Color(0.9, 0.4, 0.1, 1.0)

func _ready() -> void:   # continuación de cono.gd
	var i = 0
	# vértices de la base circular
	var px; var pz
	while i < lados:
		px = radio * cos(i * 2 * PI / lados)
		pz = -radio * sin(i * 2 * PI / lados)
		vértices.append(Vector3(px, 0, pz))
		i += 1
	
	# vértice superior del cono (punto único)
	vértices.append(Vector3(0, altura, 0))
	# vértice central de la base
	vértices.append(Vector3(0, 0, 0))
	
	# generar caras laterales del cono (corregir orientación)
	i = 0
	while i < lados:
		var siguiente = (i + 1) % lados
		# triángulo lateral con orientación correcta (sentido horario visto desde fuera)
		caras.append([i, lados, siguiente])  # lados es el índice del vértice superior
		i += 1
	
	# generar caras de la base (tapa inferior)
	i = 0
	while i < lados:
		var siguiente = (i + 1) % lados
		# triángulo de base con orientación correcta (visto desde abajo)
		caras.append([lados + 1, i, siguiente])  # lados+1 es el índice del vértice central
		i += 1
	
	# colores aleatorios para cada cara
	for j in caras.size():
		colores.append(Color(randf(), randf(), randf()))
	
	# crear el mesh usando el modo de malla con iluminación suave
	mesh = modo.malla_iluminacion_suave(vértices, caras, colores, albedo, material)
	
	# configurar el material para que sea más visible
	material.cull_mode = BaseMaterial3D.CULL_DISABLED  # ver ambas caras
	
	# asignar el mesh y material al MeshInstance3D
	cono.mesh = mesh
	cono.material_override = material
	
	# añadir el cono como hijo del nodo actual
	add_child(cono)
	
	# debug: imprimir información
	print("Cono creado con ", vértices.size(), " vértices y ", caras.size(), " caras")