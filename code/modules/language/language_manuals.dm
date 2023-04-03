/obj/item/language_manual
	icon = 'icons/obj/library.dmi'
	icon_state = "book2"
	/// Number of charges the book has, limits the number of times it can be used.
	var/charges = 1
	/// Path to a language datum that the book teaches.
	var/datum/language/language = /datum/language/common
	/// Flavour text to display when the language is successfully learned.
	var/flavour_text = "ваш разум внезапно наполняется кодовыми фразами и ответами"

/obj/item/language_manual/attack_self(mob/living/user)
	if(!isliving(user))
		return

	if(user.has_language(language))
		to_chat(user, span_boldwarning("Вы начинаете пробегаться по страницам [src], но вы уже знаете [initial(language.name)]."))
		return

	to_chat(user, span_boldannounce("Вы начинаете пробегаться по страницам [src], [flavour_text]."))

	user.grant_language(language)
	user.remove_blocked_language(language, source=LANGUAGE_ALL)
	ADD_TRAIT(user, TRAIT_TOWER_OF_BABEL, MAGIC_TRAIT) // this makes you immune to babel effects

	use_charge(user)

/obj/item/language_manual/attack(mob/living/M, mob/living/user)
	if(!istype(M) || !istype(user))
		return
	if(M == user)
		attack_self(user)
		return

	playsound(loc, SFX_PUNCH, 25, TRUE, -1)

	if(M.stat == DEAD)
		M.visible_message(span_danger("[user] шлёпает безжизненное тело [M] [src]."), span_userdanger("[user] шлёпает ваше безжизненное тело [src]."), span_hear("Вы слышите удары."))
	else if(M.has_language(language))
		M.visible_message(span_danger("[user] бьёт [M] по голове [src]!"), span_userdanger("[user] бьёт вас по голове [src]!"), span_hear("Вы слышите удары."))
	else
		M.visible_message(span_notice("[user] наказывает [M] ударами по голове при помощи [src]!"), span_boldnotice("Когда [user] шлёпает вас [src], [flavour_text]."), span_hear("You hear smacking."))
		M.grant_language(language, TRUE, TRUE, LANGUAGE_MIND)
		use_charge(user)

/obj/item/language_manual/proc/use_charge(mob/user)
	charges--
	if(!charges)
		var/turf/T = get_turf(src)
		T.visible_message(span_warning("Обложка и страницы [src] начинают меняться и расплываться, выскальзывая из рук!"))

		new /obj/item/book/manual/random(T)
		qdel(src)

/obj/item/language_manual/codespeak_manual
	name = "сборник кодовых фраз"
	desc = "Надпись на обложке: \"Кодовый разговорник(tm) - Искусно обезопасьте вашу речь идеальными метафорами, что звучат как полная бессмыслица!\""
	language = /datum/language/codespeak
	flavour_text = "ваш разум внезапно наполняется кодовыми фразами и ответами"

/obj/item/language_manual/codespeak_manual/unlimited
	name = "расширенный сборник кодовых фраз"
	charges = INFINITY

/obj/item/language_manual/roundstart_species

/obj/item/language_manual/roundstart_species/Initialize(mapload)
	. = ..()
	language = pick( \
		/datum/language/voltaic, \
		/datum/language/nekomimetic, \
		/datum/language/draconic, \
		/datum/language/moffic, \
		/datum/language/calcic \
	)
	name = "Язык: [initial(language.name)]"
	desc = "Надпись на обложке:: \"[initial(language.name)] для Ксеносов - Выучьте языки галактики за секунды.\""
	flavour_text = "вы чувствуете своё мастерство в новом языке - [initial(language.name)]"

/obj/item/language_manual/roundstart_species/unlimited
	charges = INFINITY

/obj/item/language_manual/roundstart_species/unlimited/Initialize(mapload)
	. = ..()
	name = "расширенное издание Язык: [initial(language.name)]"

/obj/item/language_manual/roundstart_species/five
	charges = 5

/obj/item/language_manual/roundstart_species/five/Initialize(mapload)
	. = ..()
	name = "уникальное издание Язык: [initial(language.name)]"

// So drones can teach borgs and AI dronespeak. For best effect, combine with mother drone lawset.
/obj/item/language_manual/dronespeak_manual
	name = "учебник дронского языка"
	desc = "Надпись на обложке: \"Понимание Дронского - рекордно безуспешное занятие.\" Книга целиком написана бинарным кодом, вряд-ли это поймёт что-то не кремниевое."
	language = /datum/language/drone
	flavour_text = "околесица дронов внезапно обретает смысл"
	charges = INFINITY

/obj/item/language_manual/dronespeak_manual/attack(mob/living/M, mob/living/user)
	// If they are not drone or silicon, we don't want them to learn this language.
	if(!(isdrone(M) || issilicon(M)))
		M.visible_message(span_danger("[user] бьёт [M] по голове [src]!"), span_userdanger("[user] бьёт вас по голове [src]!"), span_hear("Вы слышите удары."))
		return

	return ..()

/obj/item/language_manual/dronespeak_manual/attack_self(mob/living/user)
	if(!(isdrone(user) || issilicon(user)))
		to_chat(user, span_danger("Вы бьёте себя по голове при помощи [src]!"))
		return

	return ..()
