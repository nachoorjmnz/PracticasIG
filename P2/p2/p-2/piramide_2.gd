extends Node3D
@export var altura : float =0.5
@export var long : float=1.5

func _ready():
	var piramide = crear_piramide(altura)
	var mesh_instance = MeshInstance3D.new()
	var material = StandardMaterial3D.new()
	material.vertex_color_use_as_albedo = true
	mesh_instance.mesh = piramide
	mesh_instance.material_override=material
	add_child(mesh_instance)
	
	
func crear_piramide(h: float) -> ArrayMesh:
	var st = SurfaceTool.new()
	st.begin (Mesh.PRIMITIVE_TRIANGLES)

	
	var p1 = Vector3( -0.5, 0, 0)
	var p2 = Vector3( -0.5, 1, 0)
	var p3 = Vector3( 0.5, 0, 0)
	var p4 = Vector3( 0.5, 1, 0)

	var apex = Vector3(0, h, long)
	
	var color = [
		Color.REBECCA_PURPLE,
		Color.AQUA,
		Color.DARK_GOLDENROD,
		Color.DEEP_PINK,
		Color(1, 0.7, 1),
		Color(0.5, 0.65, 0.1)
	]
	 
	_add_triangulo_coloreado(st, p1, p2, apex, color[0])
	_add_triangulo_coloreado(st, p2, p3, apex, color[1])
	_add_triangulo_coloreado(st, p3, p4, apex, color[2])
	_add_triangulo_coloreado(st, p4, p1, apex, color[3])
	_add_triangulo_coloreado(st, p1, p3, p2, color[4]) 
	_add_triangulo_coloreado(st, p1, p4, p3, color[5])
 	
	return st.commit()

func _add_triangulo_coloreado(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, color: Color):
	st.set_normal(Plane(a, b, c).normal)
	st.set_color(color)
	st.add_vertex(a)
	st.set_color(color)
	st.add_vertex(b)
	st.set_color(color)
	st.add_vertex(c)
