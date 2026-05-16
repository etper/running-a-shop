extends Node2D

var can_input = true

@onready var symptom_label = $Art/SpeechBubble/CustomerPanel/SymptomLabel
@onready var money_label = $MoneyLabel
@onready var suspicion_bar = $SuspicionBar
@onready var timer_label = $TimerLabel

var suspicion_bar_original_pos = Vector2.ZERO

@onready var game_over_panel = $GameOverUI/Panel
@onready var final_money_label = $GameOverUI/Panel/FinalMoneyLabel
@onready var timer = $Timer

@onready var customer_name_label = $Art/SpeechBubble/CustomerPanel/CustomerNameLabel

@onready var flash_rect = $FlashRect
@onready var feedback_label = $FeedbackLabel
@onready var reaction_label = $ReactionLabel
@onready var feedback_timer = $FeedbackTimer

@onready var vignette = $Vignette

var time_left = 60

var customer_names = [
	"BOB",
	"SARAH",
	"MIKE",
	"LINDA",
	"GARY"
]

var customers = []
var current_customer = null

var symptom_pool = [
	{
		"symptom": "HEADACHE",
		"correct_drug": "Red"
	},
	{
		"symptom": "COUGH",
		"correct_drug": "Blue"
	},
	{
		"symptom": "FEVER",
		"correct_drug": "Green"
	}
]

var money = 0
var suspicion = 0

func check_answer(selected_drug):
	
	if not can_input:
		return
	
	var correct = selected_drug == current_customer["correct_drug"]
	
	show_feedback(correct)
	
	if selected_drug == current_customer["correct_drug"]:
		print("Correct")
		money += 10
	else:
		print("Wrong")
		suspicion += 1
		shake_suspicion_bar()

	update_ui()

	if suspicion >= 5:
		game_over("Busted!")
		return

	hide_customer()
	await get_tree().create_timer(1.0).timeout
	serve_next_customer()

func _ready():
	for i in range(15):
		customers.append(create_customer())

	update_ui()
	serve_next_customer()
	
	suspicion_bar_original_pos = suspicion_bar.position

func _on_timer_timeout() -> void:
	time_left -= 1

	update_ui()

	print("Time left: " + str(time_left))
	
	if time_left <= 0:
		game_over("Time's up!")

func create_customer():
	var random_data = symptom_pool.pick_random()

	return {
		"name": customer_names.pick_random(),
		"symptom": random_data["symptom"],
		"correct_drug": random_data["correct_drug"]
	}

func serve_next_customer():
	hide_customer()

	await get_tree().create_timer(0.7).timeout

	if customers.size() == 0:
		print("No customers left")
		symptom_label.text = "No customers"
		return

	current_customer = customers.pop_front()

	var symptom_text = current_customer["symptom"]

	print("Customer symptom: " + symptom_text)

	customer_name_label.text = current_customer["name"]
	symptom_label.text = current_customer["symptom"]

	show_customer()

func _on_button_pressed() -> void:
	check_answer("Red")

func _on_button_2_pressed() -> void:
	check_answer("Blue")

func _on_button_3_pressed() -> void:
	check_answer("Green")

func update_ui():
	money_label.text = "Money" +  "\n $" + str(money)
	suspicion_bar.value = suspicion
	
	var minutes = time_left / 60
	var seconds = time_left % 60

	timer_label.text = "TIME\n%02d:%02d" % [minutes, seconds]

	update_vignette()

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func game_over(reason):
	timer.stop()

	game_over_panel.visible = true
	final_money_label.text = reason + "\nMoney Earned: $" + str(money)

func show_feedback(correct):
	flash_rect.visible = true
	feedback_label.visible = false
	reaction_label.visible = false

	if correct:
		play_flash_pulse(Color(0, 1, 0))
		feedback_label.text = "CORRECT"
		
		var reactions = [
			"Finally, relief.",
			"My spine stopped humming.",
			"You’re a miracle worker.",
			"I can feel my teeth again."
		]

		reaction_label.text = reactions.pick_random()

	else:
		play_flash_pulse(Color(1, 0, 0))
		feedback_label.text = "WRONG"

		var reactions = [
			"My organs feel backwards.",
			"I think I'm melting.",
			"This made it worse.",
			"I can taste electricity."
		]

		reaction_label.text = reactions.pick_random()

	feedback_timer.start()

func _on_feedback_timer_timeout():
	flash_rect.visible = false
	feedback_label.visible = false
	reaction_label.visible = false

func shake_suspicion_bar():
	var shake_amount = 8

	suspicion_bar.position = suspicion_bar_original_pos + Vector2(
		randf_range(-shake_amount, shake_amount),
		0
	)

	await get_tree().create_timer(0.05).timeout

	suspicion_bar.position = suspicion_bar_original_pos

func play_red_pulse():
	flash_rect.visible = true
	flash_rect.color = Color(1, 0, 0, 0)

	var tween = create_tween()

	tween.tween_property(
		flash_rect,
		"color",
		Color(1, 0, 0, 0.35),
		0.08
	)

	tween.tween_property(
		flash_rect,
		"color",
		Color(1, 0, 0, 0),
		0.2
	)

	await tween.finished

	flash_rect.visible = false

func play_flash_pulse(color: Color):
	flash_rect.visible = true
	flash_rect.color = Color(color.r, color.g, color.b, 0)

	var tween = create_tween()

	tween.tween_property(
		flash_rect,
		"color",
		Color(color.r, color.g, color.b, 0.35),
		0.08
	)

	tween.tween_property(
		flash_rect,
		"color",
		Color(color.r, color.g, color.b, 0),
		0.2
	)

	await tween.finished

	flash_rect.visible = false

func update_vignette():
	var max_alpha = 0.45
	
	var alpha = float(suspicion) / 5.0
	alpha *= max_alpha

	vignette.color = Color(0.4, 0, 0, alpha)

func hide_customer():
	
	can_input = false
	set_buttons_enabled(false)
	
	$Art/SpeechBubble/CustomerPanel.visible = false
	$Art/SpeechBubble.visible = false
	$Art/Customer.visible = false

func show_customer():
	$Art/SpeechBubble/CustomerPanel.visible = true
	$Art/Customer.visible = true

	var bubble = $Art/SpeechBubble

	bubble.visible = true
	bubble.scale = Vector2(0.7, 0.7)
	bubble.modulate.a = 0.0

	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(
		bubble,
		"scale",
		Vector2(1.08, 1.08),
		0.12
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		bubble,
		"modulate:a",
		1.0,
		0.10
	)

	tween.chain().tween_property(
		bubble,
		"scale",
		Vector2.ONE,
		0.08
	)

	can_input = true
	set_buttons_enabled(true)

func set_buttons_enabled(enabled):
	$Button.disabled = not enabled
	$Button2.disabled = not enabled
	$Button3.disabled = not enabled
