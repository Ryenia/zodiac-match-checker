
extends Control

var zodiac_signs = [
	"♈ Aries",
	"♉ Taurus",
	"♊ Gemini",
	"♋ Cancer",
	"♌ Leo",
	"♍ Virgo",
	"♎ Libra",
	"♏ Scorpio",
	"♐ Sagittarius",
	"♑ Capricorn",
	"♒ Aquarius",
	"♓ Pisces"
]

var background_color = Color("#EDE6FF")
var purple_color = Color("#A78BFA")
var dark_color = Color("#594477")

var content: VBoxContainer


func _ready():
	randomize()
	show_friends_home()


func show_friends_home():
	for child in get_children():
		child.queue_free()

	var bg = ColorRect.new()
	bg.color = background_color
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var center = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(650, 600)
	center.add_child(panel)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 30)
	margin.add_theme_constant_override("margin_right", 30)
	margin.add_theme_constant_override("margin_top", 30)
	margin.add_theme_constant_override("margin_bottom", 30)
	panel.add_child(margin)

	content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 15)
	margin.add_child(content)

	make_label("♡ FRIENDSHIP ZODIAC CHECKER ♡", 28)
	make_label("Discover your cosmic friendship!", 18)
	make_label("✦ ☾ ✧ ♡ ✧ ☾ ✦", 25)

	make_button("START ♡").pressed.connect(show_checker)


func make_label(text_value: String, font_size: int):
	var label = Label.new()
	label.text = text_value
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", dark_color)
	content.add_child(label)


func make_button(text_value: String) -> Button:
	var button = Button.new()
	button.text = text_value
	button.custom_minimum_size = Vector2(0, 55)
	button.add_theme_font_size_override("font_size", 20)
	button.add_theme_color_override("font_color", Color.WHITE)

	var style = StyleBoxFlat.new()
	style.bg_color = purple_color
	style.set_corner_radius_all(18)

	button.add_theme_stylebox_override("normal", style)
	button.add_theme_stylebox_override("hover", style)

	content.add_child(button)
	return button


func show_checker():
	clear_content()

	make_label("♡ BEST FRIEND MATCH ♡", 28)
	make_label("Choose two zodiac signs!", 18)

	make_label("YOUR SIGN", 18)
	var first_sign = OptionButton.new()

	for sign in zodiac_signs:
		first_sign.add_item(sign)

	content.add_child(first_sign)

	make_label("YOUR FRIEND'S SIGN", 18)
	var second_sign = OptionButton.new()

	for sign in zodiac_signs:
		second_sign.add_item(sign)

	content.add_child(second_sign)

	var check_button = make_button("CHECK FRIENDSHIP ♡")

	check_button.pressed.connect(
		func():
			show_result(
				first_sign.get_item_text(first_sign.selected),
				second_sign.get_item_text(second_sign.selected)
			)
	)


func clear_content():
	for child in content.get_children():
		child.queue_free()


func show_result(first: String, second: String):
	clear_content()

	var score = randi_range(1, 100)

	make_label("♡ FRIENDSHIP RESULT ♡", 28)
	make_label(first + " + " + second, 20)
	make_label("💜", 65)
	make_label(str(score) + "%", 50)

	var message = ""

	if score >= 80:
		message = "Best friends written in the stars! ✨"
	elif score >= 60:
		message = "A beautiful friendship connection! 💜"
	elif score >= 40:
		message = "Your friendship has room to grow! 🌷"
	else:
		message = "Every friendship is unique! 💫"

	make_label(message, 18)
	make_label("Remember: this is just for fun!", 14)

	make_button("TRY AGAIN ♡").pressed.connect(show_checker)
	make_button("HOME").pressed.connect(show_friends_home)
