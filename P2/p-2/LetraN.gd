extends Node3D

@export var altura: float = 2.0
@export var ancho: float = 1.0
@export var grosor: float = 0.3
@export var barra: float = 0.25

var mesh_instance := MeshInstance3D.new()
var material := StandardMaterial3D.new()

func _ready() -> void:
	material.vertex_color_use_as_albedo = true
	material.albedo_color = Color.DODGER_BLUE
	mesh_instance.mesh = crear_n()
	mesh_instance.material_override = material
	add_child(mesh_instance)


func crear_n() -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var h = altura
	var w = ancho
	var t = barra
	var d = grosor / 2.0

	# Columna izquierda
	var col_izq = [
		Vector3(-w/2, 0, d),      # 0: abajo-izq-front
		Vector3(-w/2 + t, 0, d),  # 1: abajo-der-front
		Vector3(-w/2 + t, h, d),  # 2: arriba-der-front
		Vector3(-w/2, h, d)       # 3: arriba-izq-front
	]
	_add_box(st, col_izq, d, Color.RED)

	# Columna derecha
	var col_der = [
		Vector3(w/2 - t, 0, d),   # 0: abajo-izq-front
		Vector3(w/2, 0, d),       # 1: abajo-der-front
		Vector3(w/2, h, d),       # 2: arriba-der-front
		Vector3(w/2 - t, h, d)    # 3: arriba-izq-front
	]
	_add_box(st, col_der, d, Color.GREEN)

	# Diagonal mejorada
	var diagonal_base = Vector3(-w/2 + t, 0, 0)
	var diagonal_top = Vector3(w/2 - t, h, 0)
	_add_diagonal_3d(st, diagonal_base, diagonal_top, t, d, Color.YELLOW)

	return st.commit()


# Crea una caja 3D a partir de 4 vértices frontales
func _add_box(st: SurfaceTool, front: Array, depth: float, color: Color) -> void:
	var back = []
	for v in front:
		back.append(v - Vector3(0, 0, 2*depth))

	# Cara frontal
	_add_quad(st, front[0], front[1], front[2], front[3], color)
	# Cara trasera
	_add_quad(st, back[1], back[0], back[3], back[2], color)
	# Laterales
	_add_quad(st, front[0], back[0], back[3], front[3], color)  # izquierda
	_add_quad(st, front[1], front[2], back[2], back[1], color)  # derecha
	_add_quad(st, front[0], front[1], back[1], back[0], color)  # abajo
	_add_quad(st, front[3], back[3], back[2], front[2], color)  # arriba


# Crea la barra diagonal con prisma rectangular correcto
func _add_diagonal_3d(st: SurfaceTool, start: Vector3, end: Vector3, width: float, depth: float, color: Color) -> void:
	var dir = (end - start).normalized()
	var perp = Vector3(-dir.y, dir.x, 0).normalized() * width / 2.0
	
	# 4 vértices frontales de la diagonal
	var v0 = start - perp + Vector3(0, 0, depth)
	var v1 = start + perp + Vector3(0, 0, depth)
	var v2 = end + perp + Vector3(0, 0, depth)
	var v3 = end - perp + Vector3(0, 0, depth)
	
	# 4 vértices traseros
	var v4 = start - perp - Vector3(0, 0, depth)
	var v5 = start + perp - Vector3(0, 0, depth)
	var v6 = end + perp - Vector3(0, 0, depth)
	var v7 = end - perp - Vector3(0, 0, depth)
	
	# Cara frontal
	_add_quad(st, v0, v1, v2, v3, color)
	# Cara trasera
	_add_quad(st, v5, v4, v7, v6, color)
	# Laterales
	_add_quad(st, v0, v4, v5, v1, color)  # base
	_add_quad(st, v2, v6, v7, v3, color)  # top
	_add_quad(st, v0, v3, v7, v4, color)  # izquierda
	_add_quad(st, v1, v5, v6, v2, color)  # derecha


# Dibuja un cuadrilátero con dos triángulos
func _add_quad(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, d: Vector3, color: Color) -> void:
	var normal = (b - a).cross(c - a).normalized()
	st.set_normal(normal)
	st.set_color(color)
	st.add_vertex(a)
	st.add_vertex(b)
	st.add_vertex(c)
	st.add_vertex(a)
	st.add_vertex(c)
	st.add_vertex(d)
