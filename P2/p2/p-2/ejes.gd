extends Node3D
@export var tam:=10

func _ready() -> void:  
	var ejes =MeshInstance3D.new()
	var material =StandardMaterial3D.new()
	var st = SurfaceTool.new()
	material.vertex_color_use_as_albedo = true
	st.begin(Mesh.PRIMITIVE_LINES) 
	st.set_color(Color(1.0, 0.0, 0.0, 1.0)) # eje X
	st.add_vertex(Vector3(tam, 0, 0))
	st.add_vertex(Vector3(-tam, 0, 0))
	st.set_color(Color(0.0, 1.0, 0.0, 1.0))  # eje Y
	st.add_vertex(Vector3(0, tam, 0))
	st.add_vertex(Vector3(0, -tam, 0))
	st.set_color(Color(0.0, 0.0, 1.0, 1.0))  # eje Z
	st.add_vertex(Vector3(0,0,tam))
	st.add_vertex(Vector3(0,0,-tam))
	ejes.mesh = st.commit()
	ejes.material_override=material
	add_child(ejes)
