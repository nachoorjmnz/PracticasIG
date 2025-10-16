extends MeshInstance3D

var perfil_peon = [
	Vector2(1.2, -1.5),
	Vector2(1.1, -1.4),
	Vector2(0.9, -1.2),
	Vector2(1.0, -1.0),
	Vector2(0.8, -0.9),
	Vector2(0.6, -0.6),
	Vector2(0.5, -0.2),
	Vector2(0.4, 0.2),
	Vector2(0.45, 0.4),
	Vector2(0.8, 0.5),
	Vector2(0.85, 0.6),
	Vector2(0.5, 0.7),
	Vector2(0.4, 0.8),
]

@export var segmentos: int = 64
@export var color_peon: Color = Color(0.3, 0.2, 0.1)  

func _ready():
	mesh = crear_mesh_revolucion(perfil_peon, segmentos)
	
	var material = StandardMaterial3D.new()
	material.albedo_color = color_peon
	material.metallic = 0.1
	material.roughness = 0.7
	set_surface_override_material(0, material)

func crear_mesh_revolucion(profile_points: Array, segs: int) -> ArrayMesh:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var angle_step = TAU / segs
	var vertex_count = profile_points.size()
	var offset_y = 1.5
	
	#todos los vértices
	var vertices = []
	for i in range(segs + 1):  # +1 para cerrar la geometría
		var angle = angle_step * i
		var cos_angle = cos(angle)
		var sin_angle = sin(angle)
		var ring_vertices = []
		
		for j in range(vertex_count):
			var point = profile_points[j]
			var vertex = Vector3(
				point.x * cos_angle,
				point.y + offset_y,
				point.x * sin_angle
			)
			ring_vertices.append(vertex)
		
		vertices.append(ring_vertices)
	
	#triángulos del cuerpo
	for i in range(segs):
		for j in range(vertex_count - 1):
			var v00 = vertices[i][j]
			var v01 = vertices[i][j + 1]
			var v10 = vertices[i + 1][j]
			var v11 = vertices[i + 1][j + 1]
			
			# Primer triángulo - orden antihorario
			st.add_vertex(v00)
			st.add_vertex(v10)
			st.add_vertex(v01)
			
			# Segundo triángulo - orden antihorario
			st.add_vertex(v01)
			st.add_vertex(v10)
			st.add_vertex(v11)
	
	# Tapa inferior
	var centro_base = Vector3(0, profile_points[0].y + offset_y, 0)
	var radio_base = profile_points[0].x
	
	for i in range(segs):
		var angle0 = angle_step * i
		var angle1 = angle_step * (i + 1)
		
		var v0 = Vector3(radio_base * cos(angle0), centro_base.y, radio_base * sin(angle0))
		var v1 = Vector3(radio_base * cos(angle1), centro_base.y, radio_base * sin(angle1))
		
		# Triángulo para tapar la base (orden antihorario)
		st.add_vertex(centro_base)
		st.add_vertex(v1)
		st.add_vertex(v0)
	
	# Tapa superior 
	var centro_tapa_superior = Vector3(0, profile_points[vertex_count - 1].y + offset_y, 0)
	var radio_tapa_superior = profile_points[vertex_count - 1].x
	
	for i in range(segs):
		var angle0 = angle_step * i
		var angle1 = angle_step * (i + 1)
		
		var v0 = Vector3(radio_tapa_superior * cos(angle0), centro_tapa_superior.y, radio_tapa_superior * sin(angle0))
		var v1 = Vector3(radio_tapa_superior * cos(angle1), centro_tapa_superior.y, radio_tapa_superior * sin(angle1))
		
		# Triángulo para tapar la parte superior (orden antihorario)
		st.add_vertex(centro_tapa_superior)
		st.add_vertex(v0)
		st.add_vertex(v1)
	
	st.generate_normals()
	return st.commit()
