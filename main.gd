extends Node2D

var time_left = 60

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
	if selected_drug == current_customer["correct_drug"]:
		print("Correct")
		money += 10
	else:
		print("Wrong")
		suspicion += 1

	print("Money: ", money)
	print("Suspicion: ", suspicion)

	serve_next_customer()

func _ready():
	for i in range(5):
		customers.append(create_customer())

	serve_next_customer()

func _on_timer_timeout() -> void:
	time_left -= 1
	print("Time left: " + str(time_left))
	
	if time_left <= 0:
		print("game over")

func create_customer():
	var random_data = symptom_pool.pick_random()

	return {
		"symptom": random_data["symptom"],
		"correct_drug": random_data["correct_drug"]
	}

func serve_next_customer():
	if customers.size() == 0:
		print("No customers left")
		return

	current_customer = customers.pop_front()

	print("Customer symptom: " + current_customer["symptom"])


func _on_button_pressed() -> void:
	check_answer("Red")

func _on_button_2_pressed() -> void:
	check_answer("Blue")

func _on_button_3_pressed() -> void:
	check_answer("Green")
