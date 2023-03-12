//predominantly positive traits
//this file is named weirdly so that positive traits are listed above negative ones

/datum/quirk/alcohol_tolerance
	name = "Устойчивость к алкоголю"
	desc = "Вы напиваетесь медленнее и ощущаете меньше негативных сторон опьянения."
	icon = "beer"
	value = 4
	mob_trait = TRAIT_ALCOHOL_TOLERANCE
	gain_text = span_notice("Вы чувствуете, словно можете выпить целую кегу пива!")
	lose_text = span_danger("Каким-то образом, вы чувствуете меньшую устойчивость к алкоголю.")
	medical_record_text = "Пациент демонстрирует сильную устойчивость к алкоголю."
	mail_goodies = list(/obj/item/skillchip/wine_taster)

/datum/quirk/apathetic
	name = "Апатичный"
	desc = "В отличие от других, вам, в принципе, на всё плевать. Полезно в таком месте."
	icon = "meh"
	value = 4
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_MOODLET_BASED
	medical_record_text = "Пациенту дали тест на апатичность, но он даже не взглянул на него."
	mail_goodies = list(/obj/item/hourglass)

/datum/quirk/apathetic/add(client/client_source)
	quirk_holder.mob_mood?.mood_modifier -= 0.2

/datum/quirk/apathetic/remove()
	quirk_holder.mob_mood?.mood_modifier += 0.2

/datum/quirk/drunkhealing
	name = "Пьяная устойчивость"
	desc = "От хорошего напитка вы чувствуете себя, словно бог. Пьянство медленно восстанавливает ваши ранения."
	icon = "wine-bottle"
	value = 8
	gain_text = span_notice("Вы думаете, что вам не помешало бы выпить.")
	lose_text = span_danger("Вам больше не кажется, что алкоголь снижает боль.")
	medical_record_text = "У пациента необычные метаболические свойства печени, и его ранения лечатся алкоголем."
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_PROCESSES
	mail_goodies = list(/obj/effect/spawner/random/food_or_drink/booze)

/datum/quirk/drunkhealing/process(delta_time)
	switch(quirk_holder.get_drunk_amount())
		if (6 to 40)
			quirk_holder.adjustBruteLoss(-0.1 * delta_time, FALSE, required_bodytype = BODYTYPE_ORGANIC)
			quirk_holder.adjustFireLoss(-0.05 * delta_time, required_bodytype = BODYTYPE_ORGANIC)
		if (41 to 60)
			quirk_holder.adjustBruteLoss(-0.4 * delta_time, FALSE, required_bodytype = BODYTYPE_ORGANIC)
			quirk_holder.adjustFireLoss(-0.2 * delta_time, required_bodytype = BODYTYPE_ORGANIC)
		if (61 to INFINITY)
			quirk_holder.adjustBruteLoss(-0.8 * delta_time, FALSE, required_bodytype = BODYTYPE_ORGANIC)
			quirk_holder.adjustFireLoss(-0.4 * delta_time, required_bodytype = BODYTYPE_ORGANIC)

/datum/quirk/empath
	name = "Эмпат"
	desc = "То ли это шестое чувство, то ли вы очень хорошо знаете язык тела, но вы можете угадать, что думают личности вокруг вас."
	value = 6 /// SKYRAT EDIT - Quirk Rebalance - Original: value = 8
	icon = "smile-beam"
	mob_trait = TRAIT_EMPATH
	gain_text = span_notice("Вы словно на одной волне со всеми остальными.")
	lose_text = span_danger("Вы чувствуете себя изолированно от остальных.")
	medical_record_text = "Пациент очень восприимчив к чужим эмоциям. Возможно, он экстрасенс? Требуется дальнейшее исследование."
	mail_goodies = list(/obj/item/toy/foamfinger)

/datum/quirk/item_quirk/clown_enjoyer
	name = "Любитель клоунов"
	desc = "Вам нравятся клоунские проделки и ваше настроение поднимается, когда вы носите свой клоунский значок."
	icon = "map-pin"
	value = 2
	mob_trait = TRAIT_CLOWN_ENJOYER
	gain_text = span_notice("Вам очень нравятся клоуны.")
	lose_text = span_danger("Клоуны больше не кажутся вам такими классными.")
	medical_record_text = "Пациенту очень нравятся клоуны."
	mail_goodies = list(
		/obj/item/bikehorn,
		/obj/item/stamp/clown,
		/obj/item/megaphone/clown,
		/obj/item/clothing/shoes/clown_shoes,
		/obj/item/bedsheet/clown,
		/obj/item/clothing/mask/gas/clown_hat,
		/obj/item/storage/backpack/clown,
		/obj/item/storage/backpack/duffelbag/clown,
		/obj/item/toy/crayon/rainbow,
		/obj/item/toy/figure/clown,
	)

/datum/quirk/item_quirk/clown_enjoyer/add_unique(client/client_source)
	give_item_to_holder(/obj/item/clothing/accessory/clown_enjoyer_pin, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/clown_enjoyer/add(client/client_source)
	var/datum/atom_hud/fan = GLOB.huds[DATA_HUD_FAN]
	fan.show_to(quirk_holder)

/datum/quirk/item_quirk/mime_fan
	name = "Любитель мимов"
	desc = "Вам нравятся проделки мимов и ваше настроение поднимается, когда вы носите свой значок мима."
	icon = "thumbtack"
	value = 2
	mob_trait = TRAIT_MIME_FAN
	gain_text = span_notice("Вам очень нравятся мимы.")
	lose_text = span_danger("Мимы больше не кажутся вам такими классными.")
	medical_record_text = "Пациенту очень нравятся мимы."
	mail_goodies = list(
		/obj/item/toy/crayon/mime,
		/obj/item/clothing/mask/gas/mime,
		/obj/item/storage/backpack/mime,
		/obj/item/clothing/under/rank/civilian/mime,
		/obj/item/reagent_containers/cup/glass/bottle/bottleofnothing,
		/obj/item/stamp/mime,
		/obj/item/storage/box/survival/hug/black,
		/obj/item/bedsheet/mime,
		/obj/item/clothing/shoes/sneakers/mime,
		/obj/item/toy/figure/mime,
		/obj/item/toy/crayon/spraycan/mimecan,
	)

/datum/quirk/item_quirk/mime_fan/add_unique(client/client_source)
	give_item_to_holder(/obj/item/clothing/accessory/mime_fan_pin, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/mime_fan/add(client/client_source)
	var/datum/atom_hud/fan = GLOB.huds[DATA_HUD_FAN]
	fan.show_to(quirk_holder)

/datum/quirk/freerunning
	name = "Ловкач"
	desc = "Вы очень хороши в быстром передвижении! Вы залезаете на столы быстрее других и не получаете урона от небольших падений."
	icon = "running"
	value = 8
	mob_trait = TRAIT_FREERUNNING
	gain_text = span_notice("Вы чувствуете себя крайне гибкими.")
	lose_text = span_danger("Вы снова чувствуете себя неуклюжими.")
	medical_record_text = "У пациента высокие показатели в кардиотренировках."
	mail_goodies = list(/obj/item/melee/skateboard, /obj/item/clothing/shoes/wheelys/rollerskates)

/datum/quirk/friendly
	name = "Дружелюбный"
	desc = "Вы обнимаетесь лучше всех, особенно в хорощем настроении."
	icon = "hands-helping"
	value = 2
	mob_trait = TRAIT_FRIENDLY
	gain_text = span_notice("Вы хотите обниматься.")
	lose_text = span_danger("Вы больше не хотите обниматься.")
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_MOODLET_BASED
	medical_record_text = "Пациент демонстрирует низкие ограничения касаемо физического контакта. Прошу другого врача заняться им."
	mail_goodies = list(/obj/item/storage/box/hug)

/datum/quirk/jolly
	name = "Радостный"
	desc = "Иногда у вас просто отличное настроение без конкретной причины."
	icon = "grin"
	value = 4
	mob_trait = TRAIT_JOLLY
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_MOODLET_BASED
	medical_record_text = "Пациент демонстрирует постоянную эутимию необычную для своего окружения. Пациент, если честно, даже слишком довольный."
	mail_goodies = list(/obj/item/clothing/mask/joy)

/datum/quirk/light_step
	name = "Легкий шаг"
	desc = "Вы аккуратно ходите; Шаги становятся тише и ходить по осколкам менее больно. Также, если вы наступите в кровь, вы не запачкаетесь."
	icon = "shoe-prints"
	value = 4
	mob_trait = TRAIT_LIGHT_STEP
	gain_text = span_notice("Вы ходите чуть аккуратнее.")
	lose_text = span_danger("Вы топаете как варвар.")
	medical_record_text = "Ловкость пациента помогает ему быть тише и скрытнее"
	mail_goodies = list(/obj/item/clothing/shoes/sandal)

/datum/quirk/item_quirk/musician
	name = "Музыкант"
	desc = "Вы умеете настраивать ручные музыкальные инструменты и играть мелодии, очищающие тело и разум."
	icon = "guitar"
	value = 2
	mob_trait = TRAIT_MUSICIAN
	gain_text = span_notice("Вы знаете всё о музыкальных инструментах.")
	lose_text = span_danger("Вы забыли, как работают музыкальные инструменты.")
	medical_record_text = "Сканирование мозга пациента показало хорошо развитую способность к музыке."
	mail_goodies = list(/obj/effect/spawner/random/entertainment/musical_instrument, /obj/item/instrument/piano_synth/headphones)

/datum/quirk/item_quirk/musician/add_unique(client/client_source)
	give_item_to_holder(/obj/item/choice_beacon/music, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/night_vision
	name = "Ночное видение"
	desc = "Вы видите в темноте чуть лучше остальных."
	icon = "eye"
	value = 4
	mob_trait = TRAIT_NIGHT_VISION
	gain_text = span_notice("Тени кажутся вам чуть менее темными.")
	lose_text = span_danger("Всё кажется чуть более тёмным.")
	medical_record_text = "Глаза пациента чуть лучше привыкают к темноте."
	mail_goodies = list(
		/obj/item/flashlight/flashdark,
		/obj/item/food/grown/mushroom/glowshroom/shadowshroom,
		/obj/item/skillchip/light_remover,
	)

/datum/quirk/night_vision/add(client/client_source)
	refresh_quirk_holder_eyes()

/datum/quirk/night_vision/remove()
	refresh_quirk_holder_eyes()

/datum/quirk/night_vision/proc/refresh_quirk_holder_eyes()
	var/mob/living/carbon/human/human_quirk_holder = quirk_holder
	var/obj/item/organ/internal/eyes/eyes = human_quirk_holder.getorgan(/obj/item/organ/internal/eyes)
	if(!eyes || eyes.lighting_cutoff)
		return
	// We've either added or removed TRAIT_NIGHT_VISION before calling this proc. Just refresh the eyes.
	eyes.refresh()

/datum/quirk/item_quirk/poster_boy
	name = "Любитель постеров"
	desc = "У вас есть отличные постеры! Повесьте их на стену, чтобы порадовать остальных."
	icon = "tape"
	value = 4
	mob_trait = TRAIT_POSTERBOY
	medical_record_text = "Пациент сообщает о сильном желании развешивать постеры по стенам."
	mail_goodies = list(/obj/item/poster/random_official)

/datum/quirk/item_quirk/poster_boy/add_unique()
	var/mob/living/carbon/human/posterboy = quirk_holder
	var/obj/item/storage/box/posterbox/newbox = new()
	newbox.add_quirk_posters(posterboy.mind)
	give_item_to_holder(newbox, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/obj/item/storage/box/posterbox
	name = "Коробка постеров"
	desc = "Вы сделали их сами!"

/// fills box of posters based on job, one neutral poster and 2 department posters
/obj/item/storage/box/posterbox/proc/add_quirk_posters(datum/mind/posterboy)
	new /obj/item/poster/quirk/crew/random(src)
	var/department = posterboy.assigned_role.paycheck_department
	if(department == ACCOUNT_CIV) //if you are not part of a department you instead get 3 neutral posters
		for(var/i in 1 to 2)
			new /obj/item/poster/quirk/crew/random(src)
		return
	for(var/obj/item/poster/quirk/potential_poster as anything in subtypesof(/obj/item/poster/quirk))
		if(initial(potential_poster.quirk_poster_department) != department)
			continue
		new potential_poster(src)

/datum/quirk/selfaware
	name = "Самосознание"
	desc = "Вы отлично знаете своё тело и можете понять, насколько серьёзно поранились."
	icon = "bone"
	value = 8
	mob_trait = TRAIT_SELF_AWARE
	medical_record_text = "У пациента несколько тревожная любовь к самодиагностике."
	mail_goodies = list(/obj/item/clothing/neck/stethoscope, /obj/item/skillchip/entrails_reader)

/datum/quirk/skittish
	name = "Пугливый"
	desc = "Вас легко напугать и вы часто прячетесь. Забегите в шкафчик, чтобы автоматически закрыть за собой дверцу, если у вас есть доступ к шкафчику. Этого можно избежать, используя режим ходьбы."
	icon = "trash"
	value = 8
	mob_trait = TRAIT_SKITTISH
	medical_record_text = "Пациент демонстрирует высокий уровень избегания угроз и любит прятаться в шкафах."
	mail_goodies = list(/obj/structure/closet/cardboard)

/datum/quirk/item_quirk/spiritual
	name = "Духовный"
	desc = "У вас есть духовная вера в Бога, природу или таинственные силы Вселенной. Вам нравится присутствие святых людей и вы чувствуете, что ваши молитвы работают лучше, чем молитвы остальных. Пребывание в церкви радует вас."
	value = 2 /// SKYRAT EDIT - Quirk Rebalance - Original: value = 4
	icon = "bible"
	mob_trait = TRAIT_SPIRITUAL
	gain_text = span_notice("Вы верите в высшие силы.")
	lose_text = span_danger("Вы теряете веру!")
	medical_record_text = "Пациент сообщает о вере в высшие силы."
	mail_goodies = list(
		/obj/item/storage/book/bible/booze,
		/obj/item/reagent_containers/cup/glass/bottle/holywater,
		/obj/item/bedsheet/chaplain,
		/obj/item/toy/cards/deck/tarot,
		/obj/item/storage/fancy/candle_box,
	)

/datum/quirk/item_quirk/spiritual/add_unique(client/client_source)
	give_item_to_holder(/obj/item/storage/fancy/candle_box, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
	give_item_to_holder(/obj/item/storage/box/matches, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/tagger
	name = "Тэггер"
	desc = "Вы опытный художник. Людям действительно будут нравиться ваши граффити и вы можете использовать принадлежности для рисования в два раза дольше."
	icon = "spray-can"
	value = 4
	mob_trait = TRAIT_TAGGER
	gain_text = span_notice("Вы умеете эффективно рисовать на стенах.")
	lose_text = span_danger("Вы забываете, как правильно рисовать на стенах.")
	medical_record_text = "Недавно пациент наблюдался в больнице из-за вероятного инцидента со вдыханием краски."
	mail_goodies = list(
		/obj/item/toy/crayon/spraycan,
		/obj/item/canvas/nineteen_nineteen,
		/obj/item/canvas/twentythree_nineteen,
		/obj/item/canvas/twentythree_twentythree
	)

/datum/quirk/item_quirk/tagger/add_unique(client/client_source)
	give_item_to_holder(/obj/item/toy/crayon/spraycan, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/throwingarm
	name = "Метатель"
	desc = "У вас крайне сильные руки! Вы можете бросать объекты дальше остальных, а ваши броски всегда попадают в цель."
	icon = "baseball"
	value = 7
	mob_trait = TRAIT_THROWINGARM
	gain_text = span_notice("Ваши руки полны энергии!")
	lose_text = span_danger("Ваши руки ослабевают.")
	medical_record_text = "Пациент демонстрирует великолепные умения бросать предметы."
	mail_goodies = list(/obj/item/toy/beach_ball/baseball, /obj/item/toy/beach_ball/holoball, /obj/item/toy/beach_ball/holoball/dodgeball)

/datum/quirk/voracious
	name = "Обжора"
	desc = "Ничто не встанет между вами и едой. Вы едите быстрее и можете есть тонны фастфуда! Вам нравится быть толстым. "
	icon = "drumstick-bite"
	value = 4
	mob_trait = TRAIT_VORACIOUS
	gain_text = span_notice("Вы ГОЛООООДНЫ.")
	lose_text = span_danger("Вы больше не ГОЛООООДНЫ.")
	mail_goodies = list(/obj/effect/spawner/random/food_or_drink/dinner)

/datum/quirk/item_quirk/signer
	name = "Знаток знаков"
	desc = "Вы отлично умеете общаться на языке знаков."
	icon = "hands"
	value = 4
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_CHANGES_APPEARANCE
	mail_goodies = list(/obj/item/clothing/gloves/radio)

/datum/quirk/item_quirk/signer/add_unique(client/client_source)
	quirk_holder.AddComponent(/datum/component/sign_language)
	var/obj/item/clothing/gloves/gloves_type = /obj/item/clothing/gloves/radio
	if(isplasmaman(quirk_holder))
		gloves_type = /obj/item/clothing/gloves/color/plasmaman/radio
	give_item_to_holder(gloves_type, list(LOCATION_GLOVES = ITEM_SLOT_GLOVES, LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/signer/remove()
	qdel(quirk_holder.GetComponent(/datum/component/sign_language))
