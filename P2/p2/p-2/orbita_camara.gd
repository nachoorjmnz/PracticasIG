extends Node3D
@export var incremento := 1.5
@export var zoom_speed: float = 5.0
@export var min_zoom: float = 2.0
@export var max_zoom: float = 15.0

var zoom_distance: float = 5.0
var camera: Camera3D

func _ready():
	camera = get_node("Camera3D") as Camera3D
	if camera:
		camera.position.z = zoom_distance
	else:
		push_error("No se encontró la cámara como hija de OrbitaCamara")

func _process(delta):
	var angulo := 0.0
	var angulo_x := 0.0
	
	if Input.is_action_pressed("orbitar_izquierda"):
		angulo -= incremento * delta
	elif Input.is_action_pressed("orbitar_derecha"):
		angulo += incremento * delta
	
	if Input.is_action_pressed("orbitar_abajo"):
		angulo_x -= incremento * delta
	elif Input.is_action_pressed("orbitar_arriba"):
		angulo_x += incremento * delta
		
	rotate_y(angulo)
	rotate_object_local(Vector3(1, 0, 0), angulo_x)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_distance = clamp(zoom_distance - zoom_speed * 0.1, min_zoom, max_zoom)
			update_camera_zoom()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_distance = clamp(zoom_distance + zoom_speed * 0.1, min_zoom, max_zoom)
			update_camera_zoom()

func update_camera_zoom():
	if camera:
		camera.position.z = zoom_distance
