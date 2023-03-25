/obj/item/organ/internal/tongue
	name = "язык"
	desc = "Мясистая мышца, чаще всего для лжи."
	icon_state = "tongue"
	visual = FALSE
	zone = BODY_ZONE_PRECISE_MOUTH
	slot = ORGAN_SLOT_TONGUE
	attack_verb_continuous = list("лижет", "слюнявит", "шлёпает", "frenches", "tongues")
	attack_verb_simple = list("лизнуть", "обслюнявить", "шлёпнуть", "french", "tongue")
	/**
	 * A cached list of paths of all the languages this tongue is capable of speaking
	 *
	 * Relates to a mob's ability to speak a language - a mob must be able to speak the language
	 * and have a tongue able to speak the language (or omnitongue) in order to actually speak said language
	 *
	 * To modify this list for subtypes, see [/obj/item/organ/internal/tongue/proc/get_possible_languages]. Do not modify directly.
	 */
	VAR_PRIVATE/list/languages_possible
	/**
	 * A list of languages which are native to this tongue
	 *
	 * When these languages are spoken with this tongue, and modifies speech is true, no modifications will be made
	 * (such as no accent, hissing, or whatever)
	 */
	var/list/languages_native
	///changes the verbage of how you speak. (Permille -> says <-, "I just used a verb!")
	///i hate to say it, but because of sign language, this may have to be a component. and we may have to do some insane shit like putting a component on a component
	var/say_mod = "говорит"
	///for temporary overrides of the above variable.
	var/temp_say_mod = ""

	/// Whether the owner of this tongue can taste anything. Being set to FALSE will mean no taste feedback will be provided.
	var/sense_of_taste = TRUE
	/// Determines how "sensitive" this tongue is to tasting things, lower is more sensitive.
	/// See [/mob/living/proc/get_taste_sensitivity].
	var/taste_sensitivity = 15
	/// Whether this tongue modifies speech via signal
	var/modifies_speech = FALSE

/obj/item/organ/internal/tongue/Initialize(mapload)
	. = ..()
	// Setup the possible languages list
	// - get_possible_languages gives us a list of language paths
	// - then we cache it via string list
	// this results in tongues with identical possible languages sharing a cached list instance
	languages_possible = string_list(get_possible_languages())

/**
 * Used in setting up the "languages possible" list.
 *
 * Override to have your tongue be only capable of speaking certain languages
 * Extend to hvae a tongue capable of speaking additional languages to the base tongue
 *
 * While a user may be theoretically capable of speaking a language, they cannot physically speak it
 * UNLESS they have a tongue with that language possible, UNLESS UNLESS they have omnitongue enabled.
 */
/obj/item/organ/internal/tongue/proc/get_possible_languages()
	RETURN_TYPE(/list)
	// This is the default list of languages most humans should be capable of speaking
	return list(
		/datum/language/common,
		/datum/language/uncommon,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/nekomimetic,
	)

/obj/item/organ/internal/tongue/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER
	if(speech_args[SPEECH_LANGUAGE] in languages_native)
		return FALSE //no changes
	modify_speech(source, speech_args)

/obj/item/organ/internal/tongue/proc/modify_speech(datum/source, list/speech_args)
	return speech_args[SPEECH_MESSAGE]

/obj/item/organ/internal/tongue/Insert(mob/living/carbon/tongue_owner, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	ADD_TRAIT(tongue_owner, TRAIT_SPEAKS_CLEARLY, SPEAKING_FROM_TONGUE)
	if (modifies_speech)
		RegisterSignal(tongue_owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

	/* This could be slightly simpler, by making the removal of the
	* NO_TONGUE_TRAIT conditional on the tongue's `sense_of_taste`, but
	* then you can distinguish between ageusia from no tongue, and
	* ageusia from having a non-tasting tongue.
	*/
	REMOVE_TRAIT(tongue_owner, TRAIT_AGEUSIA, NO_TONGUE_TRAIT)
	if(!sense_of_taste)
		ADD_TRAIT(tongue_owner, TRAIT_AGEUSIA, ORGAN_TRAIT)

/obj/item/organ/internal/tongue/Remove(mob/living/carbon/tongue_owner, special = FALSE)
	. = ..()
	REMOVE_TRAIT(tongue_owner, TRAIT_SPEAKS_CLEARLY, SPEAKING_FROM_TONGUE)
	temp_say_mod = ""
	UnregisterSignal(tongue_owner, COMSIG_MOB_SAY)
	REMOVE_TRAIT(tongue_owner, TRAIT_AGEUSIA, ORGAN_TRAIT)
	// Carbons by default start with NO_TONGUE_TRAIT caused TRAIT_AGEUSIA
	ADD_TRAIT(tongue_owner, TRAIT_AGEUSIA, NO_TONGUE_TRAIT)

/obj/item/organ/internal/tongue/could_speak_language(datum/language/language_path)
	return (language_path in languages_possible)

/obj/item/organ/internal/tongue/get_availability(datum/species/owner_species, mob/living/owner_mob)
	return owner_species.mutanttongue

/obj/item/organ/internal/tongue/lizard
	name = "остроконечный язык"
	desc = "Тонкая и длинная мышца, свойственная ящеровидным расам. Иногда частично замещает нос."
	icon_state = "tonguelizard"
	say_mod = "вышипывает"
	taste_sensitivity = 10 // combined nose + tongue, extra sensitive
	modifies_speech = TRUE
	languages_native = list(/datum/language/draconic, /datum/language/ashtongue) //SKYRAT EDIT: Ashtongue for Ashwalkers

/obj/item/organ/internal/tongue/lizard/modify_speech(datum/source, list/speech_args)
	var/static/regex/lizard_hiss = new("s+", "g")
	var/static/regex/lizard_hiSS = new("S+", "g")
	var/static/regex/lizard_kss = new(@"(\w)x", "g")
	/* // SKYRAT EDIT: REMOVAL
	var/static/regex/lizard_kSS = new(@"(\w)X", "g")
	*/
	var/static/regex/lizard_ecks = new(@"\bx([\-|r|R]|\b)", "g")
	var/static/regex/lizard_eckS = new(@"\bX([\-|r|R]|\b)", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = lizard_hiss.Replace(message, "sss")
		message = lizard_hiSS.Replace(message, "SSS")
		message = lizard_kss.Replace(message, "$1kss")
		/* // SKYRAT EDIT: REMOVAL
		message = lizard_kSS.Replace(message, "$1KSS")
		*/
		message = lizard_ecks.Replace(message, "ecks$1")
		message = lizard_eckS.Replace(message, "ECKS$1")
		//SKYRAT EDIT START: Adding russian version to autohiss
		if(CONFIG_GET(flag/russian_text_formation))
			var/static/regex/lizard_hiss_ru = new("с+", "g")
			var/static/regex/lizard_hiSS_ru = new("С+", "g")
			message = replacetext(message, "з", "с")
			message = replacetext(message, "З", "С")
			message = replacetext(message, "ж", "ш")
			message = replacetext(message, "Ж", "Ш")
			message = lizard_hiss_ru.Replace(message, "ссс")
			message = lizard_hiSS_ru.Replace(message, "ССС")
		//SKYRAT EDIT END: Adding russian version to autohiss
	speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/internal/tongue/lizard/silver
	name = "серебрянный язык"
	desc = "Генетическая ветвь высокого общества Серебрянных Чешуй, которая даёт им способность серебрения. Для них он крайне важен, а предатели общества лишаются языка силой. В общем-то, он просто синий."
	icon_state = "silvertongue"
	actions_types = list(/datum/action/item_action/organ_action/statue)

/datum/action/item_action/organ_action/statue
	name = "Стать Статуей"
	desc = "Превратиться в элегантную серебрянную статую. Её целостность напрямую связана с вашей, так что будьте хорошо уверены в своей аккуратности."
	COOLDOWN_DECLARE(ability_cooldown)

	var/obj/structure/statue/custom/statue

/datum/action/item_action/organ_action/statue/New(Target)
	. = ..()
	statue = new
	RegisterSignal(statue, COMSIG_PARENT_QDELETING, PROC_REF(statue_destroyed))

/datum/action/item_action/organ_action/statue/Destroy()
	UnregisterSignal(statue, COMSIG_PARENT_QDELETING)
	QDEL_NULL(statue)
	. = ..()

/datum/action/item_action/organ_action/statue/Trigger(trigger_flags)
	. = ..()
	if(!iscarbon(owner))
		to_chat(owner, span_warning("Ваше тело отвергает мощи этого языка!"))
		return
	var/mob/living/carbon/becoming_statue = owner
	if(becoming_statue.health < 1)
		to_chat(becoming_statue, span_danger("Вы слишком слабы, чтобы превратиться в статую!"))
		return
	if(!COOLDOWN_FINISHED(src, ability_cooldown))
		to_chat(becoming_statue, span_warning("Вы только что использовали способность, подождите слегка!"))
		return
	var/is_statue = becoming_statue.loc == statue
	to_chat(becoming_statue, span_notice("Вы начинаете [is_statue ? "оживать из формы статуи" : "вставать в величественную позу, пока ваше тело превращается в статую"]!"))
	if(!do_after(becoming_statue, (is_statue ? 5 : 30), target = get_turf(becoming_statue)))
		to_chat(becoming_statue, span_warning("Трансформация прервана!"))
		COOLDOWN_START(src, ability_cooldown, 3 SECONDS)
		return
	COOLDOWN_START(src, ability_cooldown, 10 SECONDS)

	if(statue.name == initial(statue.name)) //statue has not been set up
		statue.name = "статуя [becoming_statue.real_name]"
		statue.desc = "становление статуей [becoming_statue.real_name]"
		statue.set_custom_materials(list(/datum/material/silver=MINERAL_MATERIAL_AMOUNT*5))

	if(is_statue)
		statue.visible_message(span_danger("[statue] начинает оживать!"))
		becoming_statue.forceMove(get_turf(statue))
		statue.moveToNullspace()
		UnregisterSignal(becoming_statue, COMSIG_MOVABLE_MOVED)
	else
		becoming_statue.visible_message(span_notice("[becoming_statue] затвердевает в серебрянную статую."), span_notice("Вы стали серебрянной статуей!"))
		statue.set_visuals(becoming_statue.appearance)
		statue.forceMove(get_turf(becoming_statue))
		becoming_statue.forceMove(statue)
		statue.update_integrity(becoming_statue.health)
		RegisterSignal(becoming_statue, COMSIG_MOVABLE_MOVED, PROC_REF(human_left_statue))

	//somehow they used an exploit/teleportation to leave statue, lets clean up
/datum/action/item_action/organ_action/statue/proc/human_left_statue(atom/movable/mover, atom/oldloc, direction)
	SIGNAL_HANDLER

	statue.moveToNullspace()
	UnregisterSignal(mover, COMSIG_MOVABLE_MOVED)

/datum/action/item_action/organ_action/statue/proc/statue_destroyed(datum/source)
	SIGNAL_HANDLER

	to_chat(owner, span_userdanger("Ваше существование как чего-то живого под угрозой из-за повреждений формы статуи!"))
	if(iscarbon(owner))
		//drop everything, just in case
		var/mob/living/carbon/dying_carbon = owner
		for(var/obj/item/dropped in dying_carbon)
			if(!dying_carbon.dropItemToGround(dropped))
				qdel(dropped)
	qdel(owner)

/obj/item/organ/internal/tongue/abductor
	name = "суперязыковая матрица"
	desc = "Мистический объект, позволяющий носителям коммуницировать мгновенно. Весьма впечатляет, пока не приходится есть."
	icon_state = "tongueayylmao"
	say_mod = "тараторит"
	sense_of_taste = FALSE
	modifies_speech = TRUE
	var/mothership

/obj/item/organ/internal/tongue/abductor/attack_self(mob/living/carbon/human/tongue_holder)
	if(!istype(tongue_holder))
		return

	var/obj/item/organ/internal/tongue/abductor/tongue = tongue_holder.getorganslot(ORGAN_SLOT_TONGUE)
	if(!istype(tongue))
		return

	if(tongue.mothership == mothership)
		to_chat(tongue_holder, span_notice("[src] уже настроена на тот же канал, что и вы."))

	tongue_holder.visible_message(span_notice("[tongue_holder] holds [src] in their hands, and concentrates for a moment."), span_notice("You attempt to modify the attenuation of [src]."))
	if(do_after(tongue_holder, delay=15, target=src))
		to_chat(tongue_holder, span_notice("Вы настраиваете [src] на ваш канал."))
		mothership = tongue.mothership

/obj/item/organ/internal/tongue/abductor/examine(mob/examining_mob)
	. = ..()
	if(HAS_TRAIT(examining_mob, TRAIT_ABDUCTOR_TRAINING) || (examining_mob.mind && HAS_TRAIT(examining_mob.mind, TRAIT_ABDUCTOR_TRAINING)) || isobserver(examining_mob))
		. += span_notice("Может быть настроена на разные каналы использованием в руке.")
		if(!mothership)
			. += span_notice("Не привязан определённый материнский корабль.")
		else
			. += span_notice("Привязана к [mothership].")

/obj/item/organ/internal/tongue/abductor/modify_speech(datum/source, list/speech_args)
	//Hacks
	var/message = speech_args[SPEECH_MESSAGE]
	var/mob/living/carbon/human/user = source
	var/rendered = span_abductor("<b>[user.real_name]:</b> [message]")
	user.log_talk(message, LOG_SAY, tag="abductor")
	for(var/mob/living/carbon/human/living_mob in GLOB.alive_mob_list)
		var/obj/item/organ/internal/tongue/abductor/tongue = living_mob.getorganslot(ORGAN_SLOT_TONGUE)
		if(!istype(tongue))
			continue
		if(mothership == tongue.mothership)
			to_chat(living_mob, rendered)

	for(var/mob/dead_mob in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(dead_mob, user)
		to_chat(dead_mob, "[link] [rendered]")

	speech_args[SPEECH_MESSAGE] = ""

/obj/item/organ/internal/tongue/zombie
	name = "подгнивающий язык"
	desc = "Между полным разложением и тем, что этот язык всё ещё тут валяется пролетают сильные сомнения о том, что язык может выглядеть менее сексуально."
	icon_state = "tonguezombie"
	say_mod = "завывает"
	modifies_speech = TRUE
	taste_sensitivity = 32

// List of english words that translate to zombie phrases
GLOBAL_LIST_INIT(english_to_zombie, list())

/obj/item/organ/internal/tongue/zombie/proc/add_word_to_translations(english_word, zombie_word)
	GLOB.english_to_zombie[english_word] = zombie_word
	// zombies don't care about grammar (any tense or form is all translated to the same word)
	GLOB.english_to_zombie[english_word + plural_s(english_word)] = zombie_word
	GLOB.english_to_zombie[english_word + "ing"] = zombie_word
	GLOB.english_to_zombie[english_word + "ed"] = zombie_word

/obj/item/organ/internal/tongue/zombie/proc/load_zombie_translations()
	var/list/zombie_translation = strings("zombie_replacement.json", "zombie")
	for(var/zombie_word in zombie_translation)
		// since zombie words are a reverse list, we gotta do this backwards
		var/list/data = islist(zombie_translation[zombie_word]) ? zombie_translation[zombie_word] : list(zombie_translation[zombie_word])
		for(var/english_word in data)
			add_word_to_translations(english_word, zombie_word)
	GLOB.english_to_zombie = sort_list(GLOB.english_to_zombie) // Alphabetizes the list (for debugging)

/obj/item/organ/internal/tongue/zombie/modify_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		// setup the global list for translation if it hasn't already been done
		if(!length(GLOB.english_to_zombie))
			load_zombie_translations()

		// make a list of all words that can be translated
		var/list/message_word_list = splittext(message, " ")
		var/list/translated_word_list = list()
		for(var/word in message_word_list)
			word = GLOB.english_to_zombie[lowertext(word)]
			translated_word_list += word ? word : FALSE

		// all occurrences of characters "eiou" (case-insensitive) are replaced with "r"
		message = replacetext(message, regex(@"[eiou]", "ig"), "r")
		// all characters other than "zhrgbmna .!?-" (case-insensitive) are stripped
		message = replacetext(message, regex(@"[^zhrgbmna.!?-\s]", "ig"), "")
		// multiple spaces are replaced with a single (whitespace is trimmed)
		message = replacetext(message, regex(@"(\s+)", "g"), " ")

		var/list/old_words = splittext(message, " ")
		var/list/new_words = list()
		for(var/word in old_words)
			// lower-case "r" at the end of words replaced with "rh"
			word = replacetext(word, regex(@"\lr\b"), "rh")
			// an "a" or "A" by itself will be replaced with "hra"
			word = replacetext(word, regex(@"\b[Aa]\b"), "hra")
			new_words += word

		// if words were not translated, then we apply our zombie speech patterns
		for(var/i in 1 to length(new_words))
			new_words[i] = translated_word_list[i] ? translated_word_list[i] : new_words[i]

		message = new_words.Join(" ")
		message = capitalize(message)
		speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/internal/tongue/alien
	name = "инопланетный язык"
	desc = "По последним данным ксенобиологов эволюицонное преимущество второго рта у вас во рту - \"выглядит убойно круто\"."
	icon_state = "tonguexeno"
	say_mod = "вышипывает"
	taste_sensitivity = 10 // LIZARDS ARE ALIENS CONFIRMED
	modifies_speech = TRUE // not really, they just hiss

// Aliens can only speak alien and a few other languages.
/obj/item/organ/internal/tongue/alien/get_possible_languages()
	return list(
		/datum/language/xenocommon,
		/datum/language/common,
		/datum/language/uncommon,
		/datum/language/draconic, // Both hiss?
		/datum/language/monkey,
	)

/obj/item/organ/internal/tongue/alien/modify_speech(datum/source, list/speech_args)
	var/datum/saymode/xeno/hivemind = speech_args[SPEECH_SAYMODE]
	if(hivemind)
		return

	playsound(owner, SFX_HISS, 25, TRUE, TRUE)

/obj/item/organ/internal/tongue/bone
	name = "костяной \"язык\""
	desc = "По-видимому, скелеты издают разные звуки колебанием своих зубов, отсюда же их характерное дребезжание."
	icon_state = "tonguebone"
	say_mod = "простукивает"
	attack_verb_continuous = list("кусает", "отстукивает", "chomps", "enamelles", "bones")
	attack_verb_simple = list("укусить", "отстучать", "chomp", "enamel", "bone")
	sense_of_taste = FALSE
	modifies_speech = TRUE
	var/chattering = FALSE
	var/phomeme_type = "sans"
	var/list/phomeme_types = list("sans", "papyrus")

/obj/item/organ/internal/tongue/bone/Initialize(mapload)
	. = ..()
	phomeme_type = pick(phomeme_types)

// Bone tongues can speak all default + calcic
/obj/item/organ/internal/tongue/bone/get_possible_languages()
	return ..() + /datum/language/calcic

/obj/item/organ/internal/tongue/bone/modify_speech(datum/source, list/speech_args)
	if (chattering)
		chatter(speech_args[SPEECH_MESSAGE], phomeme_type, source)
	switch(phomeme_type)
		if("sans")
			speech_args[SPEECH_SPANS] |= SPAN_SANS
		if("papyrus")
			speech_args[SPEECH_SPANS] |= SPAN_PAPYRUS

/obj/item/organ/internal/tongue/bone/plasmaman
	name = "плазменно-костяной \"язык\""
	desc = "Словно ожившие скелеты, Плазмамены вибрируют своими зубами в определённом порядке для изображения речи."
	icon_state = "tongueplasma"
	modifies_speech = FALSE

/obj/item/organ/internal/tongue/robot
	name = "синтезатор речи"
	desc = "Синтезатор голоса, позволяющий контактировать с органическими формами жизни."
	status = ORGAN_ROBOTIC
	organ_flags = NONE
	icon_state = "tonguerobot"
	say_mod = "проговаривает"
	attack_verb_continuous = list("гудит", "гудит")
	attack_verb_simple = list("гудеть", "гудеть")
	modifies_speech = TRUE
	taste_sensitivity = 25 // not as good as an organic tongue

/obj/item/organ/internal/tongue/robot/can_speak_language(language)
	return TRUE // THE MAGIC OF ELECTRONICS

/obj/item/organ/internal/tongue/robot/modify_speech(datum/source, list/speech_args)
	speech_args[SPEECH_SPANS] |= SPAN_ROBOT

/obj/item/organ/internal/tongue/snail
	name = "радула"
	color = "#96DB00" // TODO proper sprite, rather than recoloured pink tongue
	desc = "Грубоватая лента со множеством мелких зубцов. Как побочный эффект, это заставляет всех улиток говорить ОООООЧЧЧЧЧЕЕЕЕЕНННННЬ МЕЕЕЕЕЕЕЕДЛЛЛЕЕЕЕНННООО."
	modifies_speech = TRUE

/* SKYRAT EDIT START - Roundstart Snails: Less annoying speech.
/obj/item/organ/internal/tongue/snail/modify_speech(datum/source, list/speech_args)
	var/new_message
	var/message = speech_args[SPEECH_MESSAGE]
	for(var/i in 1 to length(message))
		if(findtext("ABCDEFGHIJKLMNOPWRSTUVWXYZabcdefghijklmnopqrstuvwxyz", message[i])) //Im open to suggestions
			new_message += message[i] + message[i] + message[i] //aaalllsssooo ooopppeeennn tttooo sssuuuggggggeeessstttiiiooonsss
		else
			new_message += message[i]
	speech_args[SPEECH_MESSAGE] = new_message
*/ // SKYRAT EDIT END

/obj/item/organ/internal/tongue/ethereal
	name = "электрический разрядник"
	desc = "Хитро устроенный орган этереалов, способный синтезировать речь электрическими разрядами."
	icon_state = "electrotongue"
	say_mod = "протрескивает"
	taste_sensitivity = 10 // ethereal tongues function (very loosely) like a gas spectrometer: vaporising a small amount of the food and allowing it to pass to the nose, resulting in more sensitive taste
	attack_verb_continuous = list("shocks", "jolts", "zaps")
	attack_verb_simple = list("shock", "jolt", "zap")

// Ethereal tongues can speak all default + voltaic
/obj/item/organ/internal/tongue/ethereal/get_possible_languages()
	return ..() + /datum/language/voltaic

/obj/item/organ/internal/tongue/cat
	name = "кошачий язык"
	desc = "Мясистая мышца, чаще всего для мяуканья."
	say_mod = "мяукает"

/obj/item/organ/internal/tongue/bananium
	name = "бананиумный язык"
	desc = "Бананиумная минеральная структура, обычно для бибиканья."
	say_mod = "бипкает"

	icon = 'icons/obj/weapons/items_and_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/horns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/horns_righthand.dmi'
	icon_state = "gold_horn"

/obj/item/organ/internal/tongue/jelly
	name = "желеобразный язык"
	desc = "Ах... Звучит не так, как предполагалось. Звучит как Птица Космо-осени."
	say_mod = "chirps"

/obj/item/organ/internal/tongue/monkey
	name = "примитивный язык"
	desc = "Для агрессивных воплей. И потребления бананов."
	say_mod = "вопит"

/obj/item/organ/internal/tongue/moth
	name = "мотыльковый"
	desc = "У мотыльков нет языков. Кто-нибудь, бога к телефону, передайте, что это неправильно."
	say_mod = "трепещет"

/obj/item/organ/internal/tongue/zombie
	name = "подгнивающий язык"
	desc = "Заставляет вас говорить так, будто вы у стоматолога, и вы абсолютно отказываетесь сплёвывать, ведь забыли сказать, что у вас аллергия на космических моллюсков."
	say_mod = "завывает"

/obj/item/organ/internal/tongue/mush
	name = "Грибозык"
	desc = "Этим вы пуфаете. Ясно?"
	say_mod = "пуфает"

	icon = 'icons/obj/hydroponics/seeds.dmi'
	icon_state = "mycelium-angel"
