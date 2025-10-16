extends Node3D
@export var altura: float = 1.5  # Altura de la pirámide

var mesh_instance := MeshInstance3D.new()
var material := StandardMaterial3D.new()

func _ready():
	material.vertex_color_use_as_albedo = true 
	mesh_instance.mesh = crear_piramide(altura, true) 
	mesh_instance.material_override = material
	add_child(mesh_instance)  


# --- FUNCIÓN 1 y 2: Crear pirámide (sin y con iluminación) ---
func crear_piramide(h: float, unshaded: bool, colores: Array = []) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)  

	if unshaded:
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED  # Sin sombras
	else:
		material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL  # Con iluminación
		material.disable_ambient_light = false
		material.albedo_color = Color(1, 1, 1)

	# Definimos los vértices de la base y el vértice superior
	var p1 = Vector3(-0.5, 0, -0.5)
	var p2 = Vector3(0.5, 0, -0.5)
	var p3 = Vector3(0.5, 0, 0.5)
	var p4 = Vector3(-0.5, 0, 0.5)
	var apex = Vector3(0, h, 0)

	if colores.is_empty():
		colores = [
			Color.REBECCA_PURPLE,
			Color.AQUA,
			Color.DARK_GOLDENROD,
			Color.DEEP_PINK,
			Color(1, 0.7, 1),
			Color(0.5, 0.65, 0.1)
		]

	# Caras laterales
	_add_triangulo_coloreado(st, p1, p2, apex, colores[0])
	_add_triangulo_coloreado(st, p2, p3, apex, colores[1])
	_add_triangulo_coloreado(st, p3, p4, apex, colores[2])
	_add_triangulo_coloreado(st, p4, p1, apex, colores[3])

	# Base (dos triángulos)
	_add_triangulo_coloreado(st, p1, p3, p2, colores[4])
	_add_triangulo_coloreado(st, p1, p4, p3, colores[5])

	return st.commit() 


func crear_piramide_por_vertices(h: float, unshaded: bool) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	if unshaded:
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	else:
		material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL

	var p1 = Vector3(-0.5, 0, -0.5)
	var p2 = Vector3(0.5, 0, -0.5)
	var p3 = Vector3(0.5, 0, 0.5)
	var p4 = Vector3(-0.5, 0, 0.5)
	var apex = Vector3(0, h, 0)

	var c1 = Color.RED
	var c2 = Color.GREEN
	var c3 = Color.BLUE
	var c4 = Color.YELLOW
	var c5 = Color.MAGENTA

	# Caras laterales con colores interpolados
	_add_triangulo_vertex_colored(st, p1, c1, p2, c2, apex, c5)
	_add_triangulo_vertex_colored(st, p2, c2, p3, c3, apex, c5)
	_add_triangulo_vertex_colored(st, p3, c3, p4, c4, apex, c5)
	_add_triangulo_vertex_colored(st, p4, c4, p1, c1, apex, c5)

	# Base inferior (dos triángulos)
	_add_triangulo_vertex_colored(st, p1, c1, p3, c3, p2, c2)
	_add_triangulo_vertex_colored(st, p1, c1, p4, c4, p3, c3)

	return st.commit()


# --- FUNCIÓN 5: Crear una malla invisible ---
func crear_piramide_invisible() -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	# No añadimos vértices para que  la malla no se dibuja
	return st.commit()


func _add_triangulo_coloreado(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, color: Color):
	st.set_normal(Plane(a, b, c).normal)  
	st.set_color(color)
	st.add_vertex(a)
	st.set_color(color)
	st.add_vertex(b)
	st.set_color(color)
	st.add_vertex(c)

func _add_triangulo_vertex_colored(st: SurfaceTool, a: Vector3, ca: Color, b: Vector3, cb: Color, c: Vector3, cc: Color):
	st.set_normal(Plane(a, b, c).normal)
	st.set_color(ca)
	st.add_vertex(a)
	st.set_color(cb)
	st.add_vertex(b)
	st.set_color(cc)
	st.add_vertex(c)


# --- CONTROL DE TECLAS ---
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		match event.keycode:
			KEY_1:
				mesh_instance.mesh = crear_piramide(altura, true)   # 1: sin iluminación
			KEY_2:
				mesh_instance.mesh = crear_piramide(altura, false)  # 2: con iluminación
			KEY_3:
				var random_colors := []
				for i in range(6):
					random_colors.append(Color(randf(), randf(), randf()))  # 3: colores aleatorios
				mesh_instance.mesh = crear_piramide(altura, true, random_colors)
			KEY_4:
				mesh_instance.mesh = crear_piramide_por_vertices(altura, true)  # 4: colores por vertices
			KEY_5:
				mesh_instance.mesh = crear_piramide_invisible()     # 5: malla invisible
