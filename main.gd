extends Node2D

@onready var symptom_label = $CustomerPanel/SymptomLabel
@onready var money_label = $MoneyLabel
@onready var suspicion_bar = $SuspicionBar
@onready var timer_label = $TimerLabel

@onready var game_over_panel = $GameOverUI/Panel
@onready var final_money_label = $GameOverUI/Panel/FinalMoneyLabel
@onready var timer = $Timer

@onready var customer_name_label = $CustomerPanel/CustomerNameLabel

@onready var flash_rect = $FlashRect
@onready var feedback_label = $FeedbackLabel
@onready var reaction_label = $ReactionLabel
@onready var feedback_timer = $FeedbackTimer

var time_left = 60

var customer_names = [
	"Bob",
	"Sarah",
	"Mike",
	"Linda",
	"Gary"
]

var customers = []
var current_customer = null

var symptom_pool = [
	{
		"symptom": "Headache",
		"correct_drug": "Red"
	},
	{
		"symptom": "Cough",
		"correct_drug": "Blue"
	},
	{
		"symptom": "Fever",
		"correct_drug": "Green"
	}
]

var money = 0
var suspicion = 0

func check_answer(selected_drug):
	var correct = selected_drug == current_customer["correct_drug"]
	
	show_feedback(correct)
	
	if selected_drug == current_customer["correct_drug"]:
		print("Correct")
		money += 10
	else:
		print("Wrong")
		suspicion += 1

	update_ui()

	if suspicion >= 5:
		game_over("Busted!")
		return

	serve_next_customer()

func _ready():
	for i in range(15):
		customers.append(create_customer())

	update_ui()
	serve_next_customer()

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
	if customers.size() == 0:
		print("No customers left")
		symptom_label.text = "No customers"
		return

	current_customer = customers.pop_front()

	var symptom_text = current_customer["symptom"]

	print("Customer symptom: " + symptom_text)

	symptom_label.text = "Symptom: " + symptom_text
	
	customer_name_label.text = current_customer["name"]
	symptom_label.text = current_customer["symptom"]

func _on_button_pressed() -> void:
	check_answer("Red")

func _on_button_2_pressed() -> void:
	check_answer("Blue")

func _on_button_3_pressed() -> void:
	check_answer("Green")

func update_ui():
	money_label.text = "Money: $" + str(money)
	suspicion_bar.value = suspicion
	timer_label.text = "Time: " + str(time_left)

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
		flash_rect.color = Color(0, 1, 0, 0.35)
		feedback_label.text = "CORRECT"
		
		var reactions = [
			"Finally, relief.",
			"My spine stopped humming.",
			"You’re a miracle worker.",
			"I can feel my teeth again."
		]

		reaction_label.text = reactions.pick_random()

	else:
		flash_rect.color = Color(1, 0, 0, 0.35)
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
