
extends Control

# =====================================
#       PINK ZODIAC WORLD
# =====================================

var current_mode = "love"

var zodiac_signs = [
	"♈ Aries", "♉ Taurus", "♊ Gemini",
	"♋ Cancer", "♌ Leo", "♍ Virgo",
	"♎ Libra", "♏ Scorpio", "♐ Sagittarius",
	"♑ Capricorn", "♒ Aquarius", "♓ Pisces"
]

var pink = Color("#F7A6D2")
var light_pink = Color("#FFD6EC")
var dark_pink = Color("#A64D78")
var purple = Color("#B99AEF")
var dark_purple = Color("#26133F")
var white_pink = Color("#FFF8FC")
var dark = Color("#71415C")

var panel
var content

var stars: Array = []
var zodiac_symbols: Array = []
var elapsed := 0.0

var music_player: AudioStreamPlayer


# =====================================
# READY
# =====================================

func _ready():
	randomize()
	setup_background()
	setup_music()
	setup_panel()
	show_home()


# =====================================
# BACKGROUND MUSIC
# =====================================

func setup_music():
	music_player = AudioStreamPlayer.new()
	music_player.name = "BackgroundMusic"
	music_player.volume_db = -8.0
	add_child(music_player)

	var music_path = "res://sounds/background.mp3"

	if ResourceLoader.exists(music_path):
		music_player.stream = load(music_path)
		music_player.play()
	else:
		print("Music not found: ", music_path)


# =====================================
# COSMIC BACKGROUND
# =====================================

func setup_background():

	var bg = ColorRect.new()
	bg.name = "CosmicBackground"
	bg.color = dark_purple
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.z_index = -10
	add_child(bg)

	# Pink glowing circles

	for i in range(12):
		var glow = ColorRect.new()
		glow.color = Color(0.75, 0.25, 0.65, 0.10)
		glow.size = Vector2(180, 180)
		glow.position = Vector2(
			randf_range(0, 900),
			randf_range(0, 650)
		)
		glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
		glow.z_index = -9
		add_child(glow)

	# Falling stars

	for i in range(120):
		var star = Label.new()

		star.text = "✦" if i % 2 == 0 else "✧"

		star.add_theme_font_size_override(
			"font_size",
			randi_range(9, 25)
		)

		star.add_theme_color_override(
			"font_color",
			light_pink
		)

		star.position = Vector2(
			randf_range(0, 1000),
			randf_range(0, 700)
		)

		star.mouse_filter = Control.MOUSE_FILTER_IGNORE
		star.z_index = -8
		add_child(star)

		stars.append({
			"node": star,
			"speed": randf_range(8.0, 30.0),
			"phase": randf_range(0.0, 6.28)
		})

	# Floating zodiac symbols

	var symbols = [
		"♈", "♉", "♊", "♋",
		"♌", "♍", "♎", "♏",
		"♐", "♑", "♒", "♓"
	]

	for i in range(symbols.size()):
		var sign = Label.new()

		sign.text = symbols[i]

		sign.add_theme_font_size_override(
			"font_size", 42
		)

		sign.add_theme_color_override(
			"font_color", pink
		)

		sign.modulate.a = 0.35

		sign.position = Vector2(
			randf_range(20, 850),
			randf_range(30, 600)
		)

		sign.mouse_filter = Control.MOUSE_FILTER_IGNORE
		sign.z_index = -7
		add_child(sign)

		zodiac_symbols.append({
			"node": sign,
			"start_y": sign.position.y,
			"phase": randf_range(0.0, 6.28)
		})


# =====================================
# BACKGROUND ANIMATION
# =====================================

func _process(delta):

	elapsed += delta

	var screen_size = get_viewport_rect().size

	# Star animation

	for star_data in stars:

		var star = star_data["node"]

		star.position.y += star_data["speed"] * delta

		if star.position.y > screen_size.y + 20:
			star.position.y = -20
			star.position.x = randf_range(0, screen_size.x)

		var brightness = 0.55 + 0.45 * sin(
			elapsed * 2.0 + star_data["phase"]
		)

		star.modulate.a = brightness

	# Floating zodiac animation

	for sign_data in zodiac_symbols:

		var sign = sign_data["node"]

		sign.position.y = sign_data["start_y"] + sin(
			elapsed * 0.7 + sign_data["phase"]
		) * 18.0

		sign.rotation = sin(
			elapsed * 0.5 + sign_data["phase"]
		) * 0.12


# =====================================
# MAIN PANEL
# =====================================

func setup_panel():

	var center = CenterContainer.new()
	center.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	add_child(center)

	panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(720, 680)

	var style = StyleBoxFlat.new()
	style.bg_color = white_pink
	style.set_corner_radius_all(35)
	style.set_border_width_all(3)
	style.border_color = Color("#F4B3CF")

	panel.add_theme_stylebox_override("panel", style)

	center.add_child(panel)


# =====================================
# PAGE CONTENT
# =====================================

func setup_content():

	if panel.get_child_count() > 0:
		panel.get_child(0).queue_free()

	var margin = MarginContainer.new()

	margin.add_theme_constant_override("margin_left", 35)
	margin.add_theme_constant_override("margin_right", 35)
	margin.add_theme_constant_override("margin_top", 30)
	margin.add_theme_constant_override("margin_bottom", 30)

	panel.add_child(margin)

	content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 13)

	margin.add_child(content)

	content.modulate.a = 0

	var tween = create_tween()
	tween.tween_property(
		content, "modulate:a", 1.0, 0.55
	)


# =====================================
# LABEL DESIGN
# =====================================

func make_label(txt: String, size: int):

	var label = Label.new()

	label.text = txt
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", dark)

	content.add_child(label)

	return label


# =====================================
# BUTTON DESIGN
# =====================================

func make_button(txt: String):

	var button = Button.new()

	button.text = txt
	button.custom_minimum_size = Vector2(0, 52)

	button.add_theme_font_size_override("font_size", 19)
	button.add_theme_color_override("font_color", Color.WHITE)
	button.add_theme_color_override("font_hover_color", Color.WHITE)

	var normal = StyleBoxFlat.new()
	normal.bg_color = pink
	normal.set_corner_radius_all(22)
	normal.content_margin_left = 15
	normal.content_margin_right = 15

	var hover = normal.duplicate()
	hover.bg_color = dark_pink

	var pressed = normal.duplicate()
	pressed.bg_color = purple

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)

	button.mouse_entered.connect(func():
		var tween = create_tween()
		tween.tween_property(
			button, "scale", Vector2(1.035, 1.035), 0.15
		)
	)

	button.mouse_exited.connect(func():
		var tween = create_tween()
		tween.tween_property(
			button, "scale", Vector2.ONE, 0.15
		)
	)

	content.add_child(button)

	return button


# =====================================
# HOME PAGE
# =====================================

func show_home():

	setup_content()

	make_label("✧･ﾟ: *✧･ﾟ:*", 23)
	make_label("ZODIAC", 43)
	make_label("♡ LOVE & FRIENDSHIP ♡", 23)
	make_label("Discover your cosmic destiny", 18)
	make_label("☾  ✦  ♡  ✦  ☽", 30)

	make_label("Choose your journey", 20)

	var love_button = make_button("💗 LOVE MATCH")
	love_button.pressed.connect(_on_love_mode_pressed)

	var friend_button = make_button("🦋 FRIENDSHIP MATCH")
	friend_button.pressed.connect(_on_friend_mode_pressed)

	make_label("✧ Made with love & stardust ✧", 14)


# =====================================
# MODE SELECTION
# =====================================

func _on_love_mode_pressed():

	current_mode = "love"
	show_checker()


func _on_friend_mode_pressed():

	current_mode = "friend"
	show_checker()


# =====================================
# ZODIAC CHECKER
# =====================================

func show_checker():

	setup_content()

	if current_mode == "love":
		make_label("♡ LOVE COMPATIBILITY ♡", 29)
		make_label("Are your stars aligned?", 17)
	else:
		make_label("🦋 FRIENDSHIP COMPATIBILITY", 27)
		make_label("Are you cosmic besties?", 17)

	make_label("✦ YOUR ZODIAC SIGN ✦", 18)

	var first_sign = OptionButton.new()
	first_sign.custom_minimum_size = Vector2(0, 48)

	for sign in zodiac_signs:
		first_sign.add_item(sign)

	content.add_child(first_sign)

	make_label("✦ THEIR ZODIAC SIGN ✦", 18)

	var second_sign = OptionButton.new()
	second_sign.custom_minimum_size = Vector2(0, 48)

	for sign in zodiac_signs:
		second_sign.add_item(sign)

	content.add_child(second_sign)

	make_label("☾ ✧ ☽", 24)

	var check_button = make_button("REVEAL OUR MATCH ✨")

	check_button.pressed.connect(func():
		show_result(
			first_sign.get_item_text(first_sign.selected),
			second_sign.get_item_text(second_sign.selected)
		)
	)

	var back_button = make_button("← BACK HOME")
	back_button.pressed.connect(show_home)


# =====================================
# RESULT PAGE
# =====================================

func show_result(first: String, second: String):

	setup_content()

	var score = randi_range(1, 100)

	if current_mode == "love":
		make_label("♡ COSMIC LOVE RESULT ♡", 29)
	else:
		make_label("🦋 COSMIC FRIENDSHIP RESULT", 27)

	make_label(first + " ♡ " + second, 20)

	make_label("✧･ﾟ: *✧･ﾟ:*", 22)

	var score_label = make_label("0%", 65)
	score_label.add_theme_color_override("font_color", pink)

	var tween = create_tween()

	tween.tween_method(
		func(value):
			score_label.text = str(int(value)) + "%",
		0.0,
		float(score),
		2.0
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	make_label("COMPATIBILITY", 15)

	var message = ""

	if score >= 90:
		message = "✨ A PERFECT COSMIC CONNECTION!"
	elif score >= 75:
		message = "💕 The stars love your connection!"
	elif score >= 55:
		message = "🌸 A beautiful bond is possible!"
	elif score >= 35:
		message = "🦋 Your connection is unique!"
	else:
		message = "🌙 Opposites create interesting stories!"

	make_label(message, 18)
	make_label("Remember: astrology is just for fun ♡", 14)
	make_label("✦ ☾ ✧ ♡ ✧ ☽ ✦", 22)

	var again = make_button("♡ TRY AGAIN")
	again.pressed.connect(show_checker)

	var home = make_button("⌂ HOME")
	home.pressed.connect(show_home)


# =====================================
# START
# =====================================

func _ready_setup():
	setup_panel()
	show_home()
