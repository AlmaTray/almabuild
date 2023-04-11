/mob/living/carbon/human/proc/moan()

	if(!(prob(dancing / dancing_tolerance * 65)))
		return

	visible_message(span_purple("<b>[capitalize(src.real_name)]</b> [pick("стонет", "стонет в наслаждении")]."))

	var/temp_age = 0

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		temp_age = H.age

	if (gender == FEMALE && temp_age < 30)
		playsound(get_turf(src), "sound/love/shot[rand(1, 8)].ogg", 90, 1, 0)
	else
		playsound(get_turf(src), "sound/exrp/interactions/moan_[gender == FEMALE ? "f" : "m"][rand(1, 7)].ogg", 70, 1, 0)

/mob/living/carbon/human/proc/end_dance(mob/living/carbon/human/partner, target_dancise)

	var/message
	if(gender == MALE)

		if(!istype(partner))
			target_dancise = null

		switch(target_dancise)
			if(DANCE_TARGET_MOUTH)
				if(!partner.wear_mask)
					message = pick(
						"кончает прямо в рот [partner]","кончил на язык [partner]",
						"кончает в рот [partner]","заполняет рот [partner] спермой",
						"обильно кончает в рот [partner], так, что стекает изо рта",
						"кончает в ротик [partner]",
					)
					partner.reagents.add_reagent(/datum/reagent/consumable/nutriment/protein/semen, 100)
				else
					message = "кончает на лицо [partner]"
			if(DANCE_TARGET_THROAT)
				if(!partner.wear_mask)
					message = "засунул свой член как можно глубже в глотку [partner] и кончает"
					partner.reagents.add_reagent(/datum/reagent/consumable/nutriment/protein/semen, 1599)
				else
					message = "кончает на лицо [partner]"
			if(DANCE_TARGET_DANCERESS)
				if(partner.is_literally_ready_to_dance() && partner.gender == FEMALE)
					message = "кончает в вагину [partner]"
				else
					message = "кончает на живот [partner]"
			if(DANCE_TARGET_DANCOR)
				if(partner.is_literally_ready_to_dance())
					message = "кончает в зад [partner]"
				else
					message = "кончает на спинку [partner]"
			if(DANCE_TARGET_HAND)
				if(ishuman(partner))
					message = "кончает в руку [partner]"
				else
					message = "кончает на [partner]"
			if(DANCE_TARGET_CHEST)
				if(partner.is_literally_ready_to_dance() && partner.gender == FEMALE)
					message = "кончает на грудь [partner]"
				else
					message = "кончает на шею и грудь [partner]"
			if(DANCE_TO_FACE)
				if(!partner.wear_mask)
					message = "нещадно принуждает [partner] к оральному сексу"
			if(THIGH_DANCE)
				message = "удерживает [partner] в очень крепком захвате, не давая выбраться и попутно смазывая лицо спермой"
			else
				message = "кончил на пол"

		dancing = 5
		dancing_tolerance += 50

	else
		message = pick(
			"прикрывает глаза и мелко дрожит",
			"дёргается в удовлетворении",
			"замирает, закатив глаза",
			"содрогается, а затем резко расслабляется",
			"извивается в приступе сытости",
		)
		dancing -= pick(50, 55, 80, 125)

	if(gender == MALE)
		if (prob(75))
			playsound(loc, "sound/exrp/interactions/final_m[rand(1, 3)].ogg", 90, 1, 0)
		else
			playsound(loc, "sound/gachi/penetration_[rand(1, 2)].ogg", 90, 1, 0)
	else if(gender == FEMALE)
		var/temp_age = 0
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			temp_age = H.age
		if (temp_age > 30)
			playsound(loc, "sound/exrp/interactions/final_f[rand(1, 5)].ogg", 70, 1, 0)
		else
			playsound(loc, "sound/love/shot9.ogg", 90, 1, 0)

	visible_message(span_purple("<b>[capitalize(src)]</b> [message]."))

	SSblackbox.record_feedback("amount", "dances", 1)

	if(iscarbon(src))
		var/mob/living/carbon/C = src
		var/turf/floor = get_turf(src)
		if ((!locate(/obj/effect/decal/cleanable/cum) in src.loc))
			var/obj/effect/decal/cleanable/cum/spew = new(floor, C.get_static_viruses())
			spew.transfer_mob_blood_dna(src)

	multidances += 1
	if(multidances == 1)
		log_combat(partner, src, "danced on")

	flash_act(1, TRUE, FALSE, TRUE)

	if(multidances > (dancing_potency/3))
		dancing_period = 100 //dance cooldown
		adjust_drugginess(35)
	else
		dancing_period = 100
		adjust_drugginess(12)

/mob/living/carbon/human/proc/is_dancing(mob/living/carbon/human/partner, dancise)
	if(partner == last_dancer && dancise == last_dancing)
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/set_is_dancing(mob/living/carbon/human/partner, dancise)
	last_dancer = partner
	last_dancing = dancise

#define ACTOR_DANCER (1<<0)
#define VICTIM_DANCER (1<<1)

/mob/living/carbon/human/proc/do_dance(mob/living/carbon/human/partner, action_to_do)

	if(stat != CONSCIOUS)
		return

	var/message = "пританцовывает"
	var/dancing_increase = 0
	var/dancing_which = ACTOR_DANCER | VICTIM_DANCER
	var/dancing_target = null
	var/sound_to_play

	switch(action_to_do)
		if("do_dancero")
			dancing_increase = 10
			dancing_target = DANCE_TARGET_MOUTH
			dancing_which = VICTIM_DANCER
			sound_to_play = "sound/exrp/interactions/bj[rand(1, 11)].ogg"
			if(partner.is_dancing(src, DANCE_TARGET_MOUTH))
				if(prob(partner.dancing_potency))
					message = "зарывается языком в вагину [partner]"
					dancing_increase += 5
				else
					if(partner.gender == FEMALE)
						message = "лижет вагину [partner]"
					else if(partner.gender == MALE)
						message = "посасывает член [partner]"
					else
						message = "лижет член [partner]"
			else
				if(partner.gender == FEMALE)
					message = "прижимается лицом к вагине [partner]"
				else if(partner.gender == MALE)
					message = "берёт член [partner] в свой ротик"
				else
					message = "принимается лизать член [partner]"
				partner.set_is_dancing(src, DANCE_TARGET_MOUTH)

		if ("do_facedance")
			dancing_increase = 10
			dancing_target = DANCE_TARGET_MOUTH
			dancing_which = ACTOR_DANCER
			sound_to_play = "sound/exrp/interactions/oral[rand(1, 2)].ogg"
			if(is_dancing(partner, DANCE_TARGET_MOUTH))
				if(gender == FEMALE)
					message = "елозит своей вагиной по лицу [partner]"
				else if(gender == MALE)
					message = pick(
						"грубо исследует [partner] в рот",
						"сильно прижимает голову [partner] к себе",
					)
			else
				if(gender == FEMALE)
					message = "пихает [partner] лицом в свой вагину"
				else if(gender == MALE)
					if(is_dancing(partner, DANCE_TARGET_THROAT))
						message = "достал свой член из глотки [partner]"
					else
						message = "просовывает свой член еще глубже в глотку [partner]"
				else
					message = "елозит вагиной по лицу [partner]"
				set_is_dancing(partner, DANCE_TARGET_MOUTH)

		if ("do_throatdance")
			dancing_increase = 10
			dancing_target = DANCE_TARGET_MOUTH
			dancing_which = ACTOR_DANCER
			sound_to_play = "sound/exrp/interactions/oral[rand(1, 2)].ogg"
			if(is_dancing(partner, DANCE_TARGET_THROAT))
				message = pick(
					"невероятно сильно ловит клёв в глотке [partner]",
				)
				if(rand(3) == 1) // 33%
					partner.manual_emote("задыхается в захвате [src]")
					if(iscarbon(partner))
						partner.adjustOxyLoss(1)
			else if(is_dancing(partner, DANCE_TARGET_MOUTH))
				message = "суёт член глубже, заходя уже в глотку [partner]"

			else
				message = "силой запихивает свой член в глотку [partner]"
				set_is_dancing(partner , DANCE_TARGET_THROAT)

		if ("do_dancor")
			dancing_increase = 10
			dancing_target = DANCE_TARGET_DANCOR
			sound_to_play = "sound/exrp/interactions/dance[rand(1, 3)].ogg"
			if(is_dancing(partner, DANCE_TARGET_DANCOR))
				message = pick(
					"исследует [partner] в анус",
					"нежно исследует анус [partner]",
					"всаживает член в анус [partner] по самые гренки",
					"заходит в зад [partner]",
				)
			else
				message = "безжалостно прорывает анус [partner]"
				set_is_dancing(partner, DANCE_TARGET_DANCOR)

		if ("do_dance")
			dancing_increase = 10
			dancing_target = DANCE_TARGET_DANCERESS
			sound_to_play = "sound/exrp/interactions/dance[rand(1, 2)].ogg"
			if(is_dancing(partner, DANCE_TARGET_DANCERESS))
				message = "проникает в вагину [partner]"
			else
				message = "резким движением погружается внутрь [partner]"
				set_is_dancing(partner, DANCE_TARGET_DANCERESS)

		if ("do_mount")
			dancing_increase = 10
			dancing_target = DANCE_TARGET_DANCERESS
			sound_to_play = "sound/exrp/interactions/dance[rand(1, 3)].ogg"
			if(partner.is_dancing(src, DANCE_TARGET_DANCERESS))
				message = "скачет на члене [partner]"
			else
				message = "насаживает свою вагину на член [partner]"
				partner.set_is_dancing(src, DANCE_TARGET_DANCERESS)

		if ("do_assdance")
			dancing_increase = 10
			dancing_target = DANCE_TARGET_DANCOR
			sound_to_play = "sound/exrp/interactions/dance[rand(1, 3)].ogg"
			if(partner.is_dancing(src, DANCE_TARGET_DANCOR))
				message = "по-сербски прыгает на члене [partner]"
			else
				message = "опускает свой шоколадный завод на член [partner]"
				partner.set_is_dancing(src, DANCE_TARGET_DANCOR)

		if ("do_dancering")
			dancing_increase = 10
			dancing_target = null
			dancing_which = VICTIM_DANCER
			sound_to_play = "sound/exrp/interactions/champ_fingering.ogg"
			message = pick(
				"анализирует вагину [partner]",
				"измеряет глубину вагины [partner]",
				"проверяет на прочность вагину [partner]",
			)

		if ("do_fingerdance")
			dancing_increase = 10
			dancing_target = null
			dancing_which = VICTIM_DANCER
			sound_to_play = "sound/exrp/interactions/champ_fingering.ogg"
			message = pick(
				"анализирует анус [partner]",
				"измеряет глубину зада [partner]",
				"проверяет на прочность анус [partner]",
			)

		if ("do_rimdance")
			dancing_increase = 10
			dancing_target = null
			dancing_which = VICTIM_DANCER
			sound_to_play = "sound/exrp/interactions/champ_fingering.ogg"
			message = "<b>[src]</b> нюхает анус [partner]"

		if ("do_handdance")
			dancing_increase = 10
			dancing_target = DANCE_TARGET_HAND
			dancing_which = VICTIM_DANCER
			sound_to_play = "sound/exrp/interactions/bang[rand(1, 3)].ogg"
			if(partner.is_dancing(src, DANCE_TARGET_HAND))
				message = pick(
					"мастурбирует [partner]",
					"работает рукой с головкой члена [partner]",
					"быстрее водит рукой вверх и вниз по члену [partner] ",
				)
			else
				message = "нежно обхватывает член [partner] рукой"
				partner.set_is_dancing(src, DANCE_TARGET_HAND)

		if ("do_breastdance")
			dancing_increase = 10
			dancing_target = DANCE_TARGET_CHEST
			dancing_which = ACTOR_DANCER
			sound_to_play = "sound/exrp/interactions/dance[rand(1, 3)].ogg"
			if(is_dancing(partner, DANCE_TARGET_CHEST))
				message = pick(
					"исследует [partner] между грудей",
					"прокатывается у [partner] между грудей",
				)
			else
				message = "взял груди [partner] руками и ласкает ими свой член"
				set_is_dancing(partner , DANCE_TARGET_CHEST)

		if ("do_mountdance")
			dancing_increase = 1
			dancing_target = null
			dancing_which = ACTOR_DANCER
			sound_to_play = "sound/exrp/interactions/squelch[rand(1, 3)].ogg"
			if(is_dancing(partner, DANCING_FACE_WITH_DANCOR))
				message = pick(
					"усаживается на лицо [partner]",
					"сидит на лице [partner]",
				)
				set_is_dancing(partner , DANCING_FACE_WITH_DANCOR)

		if ("do_danceface")
			dancing_increase = 1
			dancing_target = null
			dancing_which = ACTOR_DANCER
			sound_to_play = "sound/exrp/interactions/foot_dry[rand(1, 4)].ogg"
			if(src.get_item_by_slot(ITEM_SLOT_FEET) != null)
				message = pick(
					"поставил [get_shoes()] подошвой на лицо [partner]",
					"опускает свои [get_shoes()] на лицо [partner] и надавливает ими",
					"грубо давит [get_shoes()] на лицо [partner]",
				)
			else
				message = pick(
					"ставит свои оголённые ноги на лицо [partner]",
					"опускает свои массивные ступни на лицо [partner], и мнёт ими его",
					"выставляет ноги на лицо [partner]",
				)
			set_is_dancing(partner , DANCING_FACE_WITH_FEET)

		if ("do_dancemouth")
			dancing_increase = 1
			dancing_target = null
			dancing_which = ACTOR_DANCER
			sound_to_play = "sound/exrp/interactions/foot_wet[rand(1, 3)].ogg"
			if(src.get_item_by_slot(ITEM_SLOT_FEET) != null)
				message = pick(
					"заставляет [partner] попробовать [get_shoes()]",
					"даёт слизать грязь с [get_shoes()] [partner]",
				)
			else
				message = pick(
					"принуждает [partner] попробовать свой грязный палец на ноге",
					"предлагает [partner] вкусить ступню",
					"прикрывает рот и нос [partner] ступнёй, затем ждёт пока [partner] отключится и резко отпускает ступню",
				)
			set_is_dancing(partner , DANCING_MOUTH_WITH_FEET)

		if ("do_eggs")
			dancing_increase = 1
			dancing_target = DANCE_TARGET_MOUTH
			dancing_which = ACTOR_DANCER
			sound_to_play = "almabuild/sound/exrp/interactions/nuts[rand(1, 4)].ogg"
			if(is_dancing(partner, DANCE_TO_FACE))
				message = pick(
					"хватает [partner] за голову и принуждает взять мошонку в рот",
					"заставляет [partner] попробовать мошонку вновь",
					"нещадно принимается пихать яйца в рот [partner] ",
				)

				set_is_dancing(partner , DANCE_TO_FACE)

		if ("do_thighs")
			dancing_increase = 10
			dancing_target = THIGH_DANCE
			var file = pick("bj10", "bj3", "foot_wet1", "foot_dry3")
			sound_to_play = "sound/exrp/interactions/[file].ogg"
			if(is_dancing(partner, THIGH_DANCE))
				if(gender == FEMALE)
					message = pick(
						"берёт в ещё более крепкий захват ногами голову [partner], блокируя его обзор целиком",
						"обхватывает голову [partner] ногами, принуждая лизать себе",
					)
				else if(gender == MALE)
					message = pick(
						"берёт в ещё более крепкий захват ногами голову [partner] блокируя его обзор целиком",
						"обхватывает голову [partner] ногами ещё сильнее и начинает усиленно пихать мошонку в рот",
					)
				else
					message = "захватывает голову [partner] ногами"
			else
				message = pick(
					"залезает на плечи [partner] и берёт в умелый захват своими ногами",
					"хватает голову [partner] ногами",
				)
				set_is_dancing(partner , THIGH_DANCE)
			if(prob(15))
				partner.adjustOxyLoss(1)

	balloon_alert_to_viewers("[message]", vision_distance = COMBAT_MESSAGE_RANGE)
	//visible_message("<span class='notice purple small'><b>[capitalize(src.name)]</b> [message].</span>")
	playsound(get_turf(src), sound_to_play, 50, 1, -1)
	if(dancing_which & ACTOR_DANCER)
		handle_post_dance(dancing_increase, dancing_target, partner)
	if(dancing_which & VICTIM_DANCER)
		partner.handle_post_dance(dancing_increase, dancing_target, src)
	partner.dir = get_dir(partner,src)
	do_dancing_animation(get_dir(src, partner))

#undef ACTOR_DANCER
#undef VICTIM_DANCER

/mob/living/carbon/human/proc/get_shoes()
	var/obj/A = get_item_by_slot(ITEM_SLOT_FEET)
	if(findtext_char(A.name,"the"))
		return copytext_char(A.name, 3, (length(A.name)) + 1)
	else
		return A.name

/mob/living/carbon/human/proc/handle_post_dance(amount, dancise, mob/living/carbon/human/partner)
	if(stat != CONSCIOUS)
		return
	if(amount)
		dancing += amount
	if (dancing >= dancing_tolerance)
		end_dance(partner, dancise)
	else
		moan()
