extends Node3D
@export var altura : float = 1.2

var tetra := MeshInstance3D.new()
var material := StandardMaterial3D.new()

func _ready() -> void:
	material.vertex_color_use_as_albedo = true
	tetra.mesh = crear_tetraedro(altura)
	tetra.material_override = material
	add_child(tetra)
	tetra.position = Vector3(2, 0, 0)


func crear_tetraedro(h: float) -> ArrayMesh:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var p1 = Vector3(-0.5, 0, -0.5)
	var p2 = Vector3(0.5, 0, -0.5)
	var p3 = Vector3(0.0, 0, 0.5)
	var apex = Vector3(0, h, 0)

	var colores = [
		Color.RED,
		Color.GREEN,
		Color.BLUE,
		Color.YELLOW
	]

	_add_triangulo_coloreado(st, p1, p2, p3, colores[0])
	_add_triangulo_coloreado(st, p1, p2, apex, colores[1])
	_add_triangulo_coloreado(st, p2, p3, apex, colores[2])
	_add_triangulo_coloreado(st, p3, p1, apex, colores[3])

	return st.commit()


func _add_triangulo_coloreado(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, color: Color) -> void:
	st.set_normal(Plane(a, b, c).normal)
	st.set_color(color)
	st.add_vertex(a)
	st.set_color(color)
	st.add_vertex(b)
	st.set_color(color)
	st.add_vertex(c)
