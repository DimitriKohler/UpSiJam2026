# Made with ChatGPT
extends Node

class_name TextManager

var dialogue := [
	["[b]Beff Jezos[/b]", "Bonjour Mario ! Bienvenue dans la grande famille AmazOwned. Nous nous réjouissons tout particulièrement de collaborer avec vous dans ce département crucial de notre entreprise. Ici, nous sommes une grande famille. Chaque employé compte, vous n'êtes pas des ressources, mais bel et bien des humains avant tout."],
	["[b]Mario Frugale[/b]", "Merci beaucoup. Je me réjouis de commencer mon travail."],
	["[b]Beff Jezos[/b]", "Donc, je disais. Vous trouverez ici sur la droite de votre établi, une pile d’emballages en carton et sur la gauche, les articles commandés par nos clients. Votre travail est très simple, il suffit de prendre un carton ..."],
	["[b]Beff Jezos[/b]", "Puis d’y glisser la commande du client ..."],
	["[b]Beff Jezos[/b]", "Pour finir, replier le carton, un peu de scotch et le colis est prêt. Tout simplement !"],
	["[b]Mario Frugale[/b]", "Parfait, merci. Je vais pouvoir commencer."],
	["[b]Beff Jezos[/b]", "Tout va bien monsieur Frugale ?"],
	["[b]Mario Frugale[/b]", "Parfaitement merci."],
	["[b]Beff Jezos[/b]", "Êtes-Vous êtes sûr de votre rythme là ? Vous me semblez un peu lent, il va falloir augmenter la cadence."],
	["[b]Mario Frugale[/b]", "Je vais faire attention Monsieur. Merci pour votre retour…"],
	["[b]Mario Frugale[/b]", "[i]C’est quand même redondant comme job… T’apprécies plus ça comme au premier jour. Dommage.[/i]"],
	["[b]Beff Jezos[/b]", "Vous êtes très lent. Je ne vous paie pas à rien faire !"],
	["[b]Mario Frugale[/b]", "[i]Un regard lancé. Tu n’es plus sûr de ne pas être qu’une simple ressource finalement, ni de tenir très longtemps…[/i]"],
	["[b]Mario Frugale[/b]", "[i]Combien de temps peux-tu tenir ? T’en peux plus. Tu n’arrives déjà plus à compter le nombre de jours, d’années passées à emballer ces ******* de colis. Vous deviene fous.[/i]"],
	["[b]Mario Frugale[/b]", "[i]Wow ! C’est GTU6. T’as toujours rêvé d’avoir ce jeu.[/i]"],
	["[b]Mario Frugale[/b]", "[i]Et si…[/i]"],
	["[b]Mario Frugale[/b]", "[i]…[/i]"],
	["[b]Mario Frugale[/b]", "[i]Tu mérites bien ça.[/i]"],
	["[b]Beff Jezos[/b]", "Rappelez-moi votre matricule ?"],
	["[b]Mario Frugale[/b]", "666 Monsieur."],
	["[b]Beff Jezos[/b]", "Mon chiffre préféré. Dépêchez-vous. Votre rendement est très mauvais. Comment voulez-vous que j’aille en vacances sur les îles si vous ne vous activez pas ?!"],
	["[b]Mario Frugale[/b]", "[i]Tu acquiesces simplement et te remets au travail.[/i]"],
	["[b]Mario Frugale[/b]", "[i]Tu vas craquer Mario… T’as aucun avenir ici, pas comme ça. Tu dois agir.[/i]"],
	["[b]Mario Frugale[/b]", "Monsieur Jezos ?"],
	["[b]Beff Jezos[/b]", "Huh ?"],
	["[b]Mario Frugale[/b]", "Est-ce que vous pouvez m’accorder cinq minutes pour aller aux toilettes s’il vous plaît ?"],
	["[b]Beff Jezos[/b]", "Euh. Non. Vous n’avez pas une gourde ?"],
	["[b]Mario Frugale[/b]", "…"],
#	["[b]Mario Frugale[/b]", "[i]T’es réellement… en train de faire ça là ?[/i]"],
	["[b]Beff Jezos[/b]", "Surtout n’oubliez jamais que vous n’êtes qu’une ressource remplaçable Marco ! Tout comme ma Edison Type L  avec 500km au compteur, bonne pour la casse, rien d’autre. Méfiez-vous."],
	["[b]Mario Frugale[/b]", "[i]Encore une fois, tu ne fais qu'obtempérer. 10 ct la minute... En plus il ne se souvient même pas de ton nom. Une famille hein.[/i]"],
	["[b]Mario Frugale[/b]", "[i]C’est vraiment ça que tu veux faire ? Toute ta vie ? T’en peux déjà plus… “Avancer”, dans ce monde ? Tu dois changer quelque chose, tu dois changer les choses. Tu dois saisir l’occasion. Rapidement.[/i]"],
	["[b]Mario Frugale[/b]", "[i]Tu vas t’en servir. Tu dois arrêter cet enfer.[/i]"],
	["[b]Mario Frugale[/b]", "Monsieur “Jeffos” ?"], #Fin A
	["[b]Beff Jezos[/b]", "“JEZOS” ! Pour qui tu te prends ?!"], #Fin A
	["[b]Mario Frugale[/b]", "Enfin libre."], #Fin A
	["[b]Beff Jezos[/b]", "Plus vite ! Encore plus vite ! Toujours plus vite !"], #Fin B
	["[b]Mario Frugale[/b]", "[i]Argh. Pas le choix. Freak on a leash.[/i]"], #Fin B
	["[b]Beff Jezos[/b]", "Vous êtes vraiment inutile ! Vous ne me servez à rien ! Rentrez chez vous que je ne vous revois plus jamais !"], #Fin C
]

var init_boss_position: Vector2 = Vector2.ZERO
var writing: bool = false

@onready var main_script: Node2D = $"../.."
@onready var dialog_view: Node2D = $".."
@onready var background: Control = $"../DialogBackground"
@onready var boss_tex_rect: TextureRect = $"../Boss"
@onready var author_label: RichTextLabel = $"../AuthorTextLabel"
@onready var dialog_label: RichTextLabel = $"../MarginContainer/DialogTextLabel"

func _ready():
	init_boss_position = boss_tex_rect.global_position
	dialog_label.mouse_filter = Control.MOUSE_FILTER_STOP
	dialog_label.gui_input.connect(_on_dialog_label_gui_input)
	main_script.current_index_changed.connect(_on_current_index_changed)
	main_script.state_changed.connect(_on_state_changed)


func _on_state_changed(new_state):
	if new_state == main_script.GameState.DIALOG:
		dialog_view.visible = true
		background.visible = true
	elif new_state == main_script.GameState.TUTO:
		dialog_view.visible = true
		background.visible = false
	else:
		dialog_view.visible = false


func _on_current_index_changed(new_index):
	if main_script.get_state() != main_script.GameState.WORK:

		if dialogue[new_index][0] == "[b]Beff Jezos[/b]":
			boss_tex_rect.visible = true
			if new_index == 2:
				boss_tex_rect.global_position = Vector2(-450, 216)
				boss_tex_rect.flip_h = true
			else:
				boss_tex_rect.flip_h = false
				boss_tex_rect.global_position = init_boss_position
		else:
			boss_tex_rect.visible = false
		
		write_dialog()
	

func _on_dialog_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if writing:
				dialog_label.visible_characters = dialogue[main_script.get_current_index()][1].length()
				writing = false
			else:
				if main_script.get_state() == main_script.GameState.DIALOG:
					main_script.next()


func write_dialog():
	var current_dialog = dialogue[main_script.get_current_index()]
	
	author_label.text = "%s" % current_dialog[0]
	print("Launch write")
	write_text_over_time(current_dialog[1])


func write_text_over_time(text: String, char_delay: float = 0.01) -> void:
	writing = true
	dialog_label.clear()
	dialog_label.visible_characters = 0
	dialog_label.bbcode_text = text  # Use bbcode if you have bold/italic formatting

	var total_chars = text.length()
	for i in range(total_chars + 1):
		if not writing:
			dialog_label.visible_characters = total_chars
			break
		dialog_label.visible_characters = i
		await get_tree().process_frame  # Wait for next frame
		await get_tree().create_timer(char_delay).timeout
	
	writing = false
		
