extends Node3D
@export var altura: float = 1.5

var mesh_instance := MeshInstance3D.new()
var material := StandardMaterial3D.new()

func _ready():
	material.vertex_color_use_as_albedo = true
	mesh_instance.mesh = crear_diamante(altura, true)
	mesh_instance.material_override = material
	add_child(mesh_instance)


func crear_diamante(h: float, unshaded: bool, colores: Array = []) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	if unshaded:
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	else:
		material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
		material.disable_ambient_light = false
		material.albedo_color = Color(1, 1, 1)

	# Vértices del diamante
	var p1 = Vector3(-0.5, 0, -0.5)
	var p2 = Vector3(0.5, 0, -0.5)
	var p3 = Vector3(0.5, 0, 0.5)
	var p4 = Vector3(-0.5, 0, 0.5)
	var apex_top = Vector3(0, h, 0)
	var apex_bottom = Vector3(0, -h, 0)

	if colores.is_empty():
		colores = [
			Color.CYAN,
			Color.MAGENTA,
			Color.YELLOW,
			Color.ORANGE,
			Color(0.2, 0.8, 0.9),
			Color(0.9, 0.6, 0.3),
			Color(0.7, 0.1, 0.9),
			Color(0.4, 0.9, 0.6)
		]

	# Parte superior
	_add_triangulo_coloreado(st, p1, p2, apex_top, colores[0])
	_add_triangulo_coloreado(st, p2, p3, apex_top, colores[1])
	_add_triangulo_coloreado(st, p3, p4, apex_top, colores[2])
	_add_triangulo_coloreado(st, p4, p1, apex_top, colores[3])

	# Parte inferior
	_add_triangulo_coloreado(st, p2, p1, apex_bottom, colores[4])
	_add_triangulo_coloreado(st, p3, p2, apex_bottom, colores[5])
	_add_triangulo_coloreado(st, p4, p3, apex_bottom, colores[6])
	_add_triangulo_coloreado(st, p1, p4, apex_bottom, colores[7])

	return st.commit()


func crear_diamante_por_vertices(h: float, unshaded: bool) -> ArrayMesh:
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
	var apex_top = Vector3(0, h, 0)
	var apex_bottom = Vector3(0, -h, 0)

	var c1 = Color.RED
	var c2 = Color.GREEN
	var c3 = Color.BLUE
	var c4 = Color.YELLOW
	var c5 = Color.MAGENTA
	var c6 = Color.CYAN

	# Parte superior
	_add_triangulo_vertex_colored(st, p1, c1, p2, c2, apex_top, c5)
	_add_triangulo_vertex_colored(st, p2, c2, p3, c3, apex_top, c5)
	_add_triangulo_vertex_colored(st, p3, c3, p4, c4, apex_top, c5)
	_add_triangulo_vertex_colored(st, p4, c4, p1, c1, apex_top, c5)

	# Parte inferior
	_add_triangulo_vertex_colored(st, p2, c2, p1, c1, apex_bottom, c6)
	_add_triangulo_vertex_colored(st, p3, c3, p2, c2, apex_bottom, c6)
	_add_triangulo_vertex_colored(st, p4, c4, p3, c3, apex_bottom, c6)
	_add_triangulo_vertex_colored(st, p1, c1, p4, c4, apex_bottom, c6)

	return st.commit()


func crear_diamante_invisible() -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
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
				mesh_instance.mesh = crear_diamante(altura, true)   # sin iluminación
			KEY_2:
				mesh_instance.mesh = crear_diamante(altura, false)  # con iluminación
			KEY_3:
				var random_colors := []
				for i in range(8):
					random_colors.append(Color(randf(), randf(), randf()))
				mesh_instance.mesh = crear_diamante(altura, true, random_colors)
			KEY_4:
				mesh_instance.mesh = crear_diamante_por_vertices(altura, true) # colores por vertices
			KEY_5:
				mesh_instance.mesh = crear_diamante_invisible()     # modo invisible
