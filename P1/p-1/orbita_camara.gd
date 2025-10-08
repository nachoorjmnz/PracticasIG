extends Node3D
@export var incremento := 1.5

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
	rotate_x(angulo_x)
