extends Node

enum QuestionType { TEXT, IMAGE, VIDEO, AUDIO }

export(Resource) var bd_quiz
export(Color) var color_right
export(Color) var color_wrong

var buttons := []
var index := 0

onready var question_texts := $question_info/txt_question
onready var question_image := $question_info/image_holder/question_image
onready var question_video := $question_info/image_holder/question_video
onready var question_audio := $question_info/image_holder/question_audio

func _ready() -> void:
	for _button in $question_holder.get_children():
		buttons.append(_button)
		
	load_quiz()

func load_quiz() -> void:
	if index >= bd_quiz.bd.size():
		print("Fim do Quiz!")
		return
		
	question_texts.text = str(bd_quiz.bd[index].question_info)
	
	for i in buttons.size():
		buttons[i].text = str(bd_quiz.bd[index].options[i])
		buttons[i].connect("pressed", self, "buttons_answer", [buttons[i]])
	match bd_quiz.bd[index].type:
			QuestionType.TEXT:
				$question_info/image_holder/question_image.hide()
			
			QuestionType.IMAGE:
				$question_info/image_holder/question_image.show()
				question_image.texture = bd_quiz.bd[index].question_image
				
			QuestionType.VIDEO:
				$question_info/image_holder/question_image.show()
				question_video.stream = bd_quiz.bd[index].question_video
				question_video.play()
				
			QuestionType.AUDIO:
				$question_info/image_holder/question_image.show()
				question_image.texture = load("res://sprites/sound.png")
				question_audio.stream = bd_quiz.bd[index].question_audio
				question_audio.play()
				
				
func buttons_answer(button) -> void:
	if bd_quiz.bd[index].correct == button.text:
		button.modulate = color_right
	else:
		button.modulate = color_wrong
	
	question_audio.stop()
	question_video.stop()
	
	yield(get_tree().create_timer(1), "timeout")
	for bt in buttons:
		bt.modulate = Color.white
		bt.disconnect("pressed", self, "buttons_answer")
	
	question_audio.stream = null
	question_video.stream = null
	index += 1
	load_quiz()
