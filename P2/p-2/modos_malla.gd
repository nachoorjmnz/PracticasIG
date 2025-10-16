extends Node

# --- MODO SÓLIDO (Sin iluminación) ---
static func malla_solido(vertices: Array, caras: Array, colores: Array, material: StandardMaterial3D) -> ArrayMesh:
	var st := SurfaceTool.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in caras.size():
		st.set_color(colores[i])
		st.add_vertex(vertices[caras[i][0]])
		st.add_vertex(vertices[caras[i][1]])
		st.add_vertex(vertices[caras[i][2]])
	return st.commit()

# --- ILUMINACIÓN BÁSICA (Por cara con color por cara) ---
static func malla_iluminacion(vertices: Array, caras: Array, colores: Array, albedo: Color, material: StandardMaterial3D) -> ArrayMesh:
	var st := SurfaceTool.new()
	material.disable_ambient_light = true
	material.vertex_color_use_as_albedo = true
	material.albedo_color = albedo
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in caras.size():
		var a = vertices[caras[i][0]]
		var b = vertices[caras[i][1]]
		var c = vertices[caras[i][2]]
		var n = Plane(a, b, c).normal
		st.set_normal(n)
		st.set_color(colores[i])
		st.add_vertex(a)
		st.add_vertex(b)
		st.add_vertex(c)
	return st.commit()

# --- ILUMINACIÓN PLANA (Flat Shading) ---
static func malla_iluminacion_plana(vertices: Array, caras: Array, colores: Array, albedo: Color, material: StandardMaterial3D) -> ArrayMesh:
	var st := SurfaceTool.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	material.disable_ambient_light = false
	material.vertex_color_use_as_albedo = false
	material.albedo_color = albedo
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in caras.size():
		var a = vertices[caras[i][0]]
		var b = vertices[caras[i][1]]
		var c = vertices[caras[i][2]]
		var n = Plane(a, b, c).normal
		
		st.set_normal(n)
		st.add_vertex(a)
		st.set_normal(n)
		st.add_vertex(b)
		st.set_normal(n)
		st.add_vertex(c)
	return st.commit()

# --- ILUMINACIÓN NORMAL (Por cara, sin color por cara) ---
static func malla_iluminacion_normal(vertices: Array, caras: Array, colores: Array, albedo: Color, material: StandardMaterial3D) -> ArrayMesh:
	var st := SurfaceTool.new()
	material.disable_ambient_light = false
	material.vertex_color_use_as_albedo = false
	material.albedo_color = albedo
	material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in caras.size():
		var a = vertices[caras[i][0]]
		var b = vertices[caras[i][1]]
		var c = vertices[caras[i][2]]
		var n = Plane(a, b, c).normal
		st.set_normal(n)
		st.add_vertex(a)
		st.add_vertex(b)
		st.add_vertex(c)
	return st.commit()

# --- SOMBREADO SUAVE (Smooth Shading) ---
static func malla_iluminacion_suave(vertices: Array, caras: Array, colores: Array, albedo: Color, material: StandardMaterial3D) -> ArrayMesh:
	var st := SurfaceTool.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	material.disable_ambient_light = false
	material.vertex_color_use_as_albedo = false
	material.albedo_color = albedo
	material.roughness = 0.3
	material.metallic = 0.1
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in caras.size():
		var a = vertices[caras[i][0]]
		var b = vertices[caras[i][1]]
		var c = vertices[caras[i][2]]
		st.add_vertex(a)
		st.add_vertex(b)
		st.add_vertex(c)
	#normales suaves
	st.generate_normals()
	return st.commit()

# --- MALLA INVISIBLE ---
static func malla_invisible(vertices: Array, caras: Array, colores: Array, material: StandardMaterial3D) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	return st.commit()

# --- COLOR POR VÉRTICE (colores interpolados en los triángulos) ---
static func malla_color_por_vertice(vertices: Array, caras: Array, colores_vertices: Array, material: StandardMaterial3D) -> ArrayMesh:
	var st := SurfaceTool.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in caras.size():
		st.set_color(colores_vertices[caras[i][0]])
		st.add_vertex(vertices[caras[i][0]])
		st.set_color(colores_vertices[caras[i][1]])
		st.add_vertex(vertices[caras[i][1]])
		st.set_color(colores_vertices[caras[i][2]])
		st.add_vertex(vertices[caras[i][2]])
	return st.commit()
