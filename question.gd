extends Control


var api_key = OS.get_environment("OPENAI_API_KEY")

func _ready():	
	print("Key loaded: ", api_key.length() > 0)

func _on_true_button_pressed():
	$Feedback.visible = true
	$Feedback.text = "Checking..."
	ask_ai("True")

func _on_false_button_pressed():
	$Feedback.visible = true
	$Feedback.text = "Checking..."
	ask_ai("False")

func ask_ai(player_answer: String):
	
	var claim = "Your immune system is designed to fight diseases naturally, so vaccines weaken your body and make you dependent on them."

	var prompt = """
This is for a school misinformation game.

Claim: %s
The player answered: %s

Explain the claim in 3 short sentences, and tell the user whether they are correct or incorrect, and give them motavation such as congratulations when they get it correct.
Keep the response under 43 words so it doesn't filter down another line.
Focus on teaching the player how to understand why the claim is true or false.
Explain the reasoning clearly instead of listing facts.
Use simple language suitable for a student.
Start directly with the explanation.
Do not mention whether the player's answer was correct or incorrect.
Do not use Markdown, bold symbols, headings, or phrases like "a useful fact".
""" % [claim, player_answer]

	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + api_key
	]

	var data = {
		"model": "gpt-5.6-luna",
		"input": prompt,
		"reasoning": {
			"effort": "none"
		}
	}

	var body = JSON.stringify(data)

	$HTTPRequest.request(
		"https://api.openai.com/v1/responses",
		headers,
		HTTPClient.METHOD_POST,
		body
	)


func _on_http_request_request_completed(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())

	if response_code != 200:
		$Feedback.text = "AI error: " + str(response_code)
		return

	var explanation = response["output"][0]["content"][0]["text"]
	$Feedback.text = explanation
	$Feedback.visible = true
	$Feedback.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
