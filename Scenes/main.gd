extends Node3D

signal focus_lost
signal focus_gained
signal pose_recentered

@export var maximum_refresh_rate := 90
var xr_interface: XRInterface
var xr_is_focussed = false



func _ready() -> void:
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR успешно инициализирован")
		var vp: Viewport = get_viewport()#переключаем вывод на вр очки
		vp.use_xr = true
		
		#Если на ПК 60ГЦ монитор, то в шлеме вместо 90 будут 60 фпс. XR интерфейсы выполняют собственную синхронизацию
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)  
		
		if RenderingServer.get_rendering_device():
			vp.vrs_mode = Viewport.VRS_XR
		elif int(ProjectSettings.get_setting("xr/openxr/foveation_level")) == 0:
			push_warning("OpenXR: Рекомендуется установить уровень фовиации на высокий в настройках проекта")
		
		xr_interface.session_begun.connect(_on_openxr_session_begun)
		xr_interface.session_visible.connect(_on_openxr_visible_state)
		xr_interface.session_focussed.connect(_on_openxr_focused_state)
		xr_interface.session_stopping.connect(_on_openxr_stopping)
		xr_interface.pose_recentered.connect(_on_openxr_pose_recentered)
		
	else:
		print("OpenXR не инициализирован, проверьте подключение гарнитуры")
		get_tree().quit()
		
	
func _on_openxr_session_begun() -> void:
	var current_refresh_rate = xr_interface.get_display_refresh_rate()
	if current_refresh_rate > 0:
		print("OpenXR:Refresh rate reported as ", str(current_refresh_rate))
	else:
		print("OpenXR: No Refresh rate given by XR runtime")
	
	var new_rate = current_refresh_rate
	var available_rates: Array = xr_interface.get_available_display_refresh_rates()
	if available_rates.size() == 0:
		new_rate = available_rates[0]
	else:
		for rate in available_rates:
			if rate > new_rate and rate <= maximum_refresh_rate:
				new_rate = rate
	
	if current_refresh_rate != new_rate:
		print("OpenXR: Установка частоты обновления на ", str(new_rate))
		xr_interface.set_display_refresh_rate(new_rate)
		current_refresh_rate = new_rate
	
	Engine.physics_ticks_per_second = current_refresh_rate

func _on_openxr_visible_state() -> void:
	if xr_is_focussed:
		print("OpenXR lost focus")
		
		xr_is_focussed = false
		
		get_tree().paused = true
		
		emit_signal("focus_lost")

func _on_openxr_focused_state() -> void:
	print("OpenXR gained focus")
	
	get_tree().paused = false
	
	emit_signal("focus_gained")

func _on_openxr_stopping() -> void:
	print("OpenXR is stopping")
	
func _on_openxr_pose_recentered() -> void:
	emit_signal("pose_recentered")	
	
	
	
	
	
	
	
	
	
	
