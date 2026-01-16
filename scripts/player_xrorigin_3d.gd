class_name Player

extends XROrigin3D

signal pumped_up(String)

@onready var function_pickup_left: XRToolsFunctionPickup = $LeftHand/FunctionPickup
@onready var function_pickup_right: XRToolsFunctionPickup = $RightHand/FunctionPickup
@onready var timer: Timer = $"../Bottle/Timer"


var stamina : float = 100:
	set(value):
		stamina = clamp(value, 0, 100)
		$RightHand/StaminaLabel.text = "Stamina: " + str(stamina)
		if stamina == 0:
			function_pickup_left.drop_object()
			function_pickup_right.drop_object()
			function_pickup_left.grab_collision_mask = ~0 & ~(1 << 2)
			function_pickup_right.grab_collision_mask = ~0 & ~(1 << 2)
		else:
			function_pickup_left.grab_collision_mask = ~0 
			function_pickup_right.grab_collision_mask = ~0

func _on_pump_up_body_entered(body: Node3D) -> void:
	if body is XRToolsPickable:
		var spec = body.get_node("Specifier")
		if spec.itemSpec == "Water":
			if body.basis.y.dot(Vector3.UP) < 0.1:
				timer.start()
				pass
		elif spec != null:
			print(spec.itemSpec)
			pumped_up.emit(spec.itemSpec)
			stamina -= body.mass / 2
	else:
		print("Ну непонятно" + str(body.name))
	pass # Replace with function body.
	
func _on_pump_up_body_exited(body: Node3D) -> void:
	if body is XRToolsPickable:
		var spec = body.get_node("Specifier")
		if spec.itemSpec == "Water":
			timer.stop()

func _on_timer_timeout() -> void:
	stamina += 1
	pass # Replace with function body.

func _on_left_pickup_has_picked_up(what: Variant) -> void:
	if function_pickup_right.picked_up_object != null:
		print("Во второй руке что то есть")
		if what.get_node("Specifier").itemSpec == "Barbell":
			print("Вы подобрали штангу")
			$Timer.stop()
	else:
		print("Вторая рука пуста")
		if what.get_node("Specifier").itemSpec == "Barbell":
			print("Вы уронили штангу")
			$Timer.start()
			

func _on_right_pickup_has_picked_up(what: Variant) -> void:
	if function_pickup_left.picked_up_object != null:
		print("Во второй руке что то есть")
		if what.get_node("Specifier").itemSpec == "Barbell":
			print("Вы подобрали штангу")
			$Timer.stop()
	else:
		print("Вторая рука пуста")
		if what.get_node("Specifier").itemSpec == "Barbell":
			print("Вы уронили штангу")
			$Timer.start()
		


func _on_right_pickup_has_dropped() -> void:
	pass # Replace with function body.


func _on_left_pickup_has_dropped() -> void:
	pass # Replace with function body.


func _on_physicsTimesr_timeout() -> void:
	function_pickup_left.drop_object()
	function_pickup_right.drop_object()
	pass # Replace with function body.
