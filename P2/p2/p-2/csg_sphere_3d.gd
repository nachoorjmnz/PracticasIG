extends CSGSphere3D

func _ready():
	var textura = load("res://Metal052A.png") as Texture2D
	
	var material = StandardMaterial3D.new()
	material.albedo_texture = textura
	
	
	material.metallic = 1.0          
	material.roughness = 0.1         
	material.specular = 1.0          
	
	self.material = material
