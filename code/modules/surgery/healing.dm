/datum/surgery/healing
	target_mobtypes = list(/mob/living)
	requires_bodypart_type = NONE
	replaced_by = /datum/surgery
	surgery_flags = SURGERY_IGNORE_CLOTHES | SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/heal,
		/datum/surgery_step/close,
	)

	var/healing_step_type
	var/antispam = FALSE

/datum/surgery/healing/can_start(mob/user, mob/living/patient)
	. = ..()
	if(isanimal(patient))
		var/mob/living/simple_animal/critter = patient
		if(!critter.healable)
			return FALSE
	if(!(patient.mob_biotypes & (MOB_ORGANIC|MOB_HUMANOID)))
		return FALSE

/datum/surgery/healing/New(surgery_target, surgery_location, surgery_bodypart)
	..()
	if(healing_step_type)
		steps = list(
			/datum/surgery_step/incise/nobleed,
			healing_step_type, //hehe cheeky
			/datum/surgery_step/close)

/datum/surgery_step/heal
	name = "repair body (hemostat)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCREWDRIVER = 65,
		/obj/item/pen = 55)
	repeatable = TRUE
	time = 25
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'
	var/brutehealing = 0
	var/burnhealing = 0
	var/brute_multiplier = 0 //multiplies the damage that the patient has. if 0 the patient wont get any additional healing from the damage he has.
	var/burn_multiplier = 0

/// Returns a string letting the surgeon know roughly how much longer the surgery is estimated to take at the going rate
/datum/surgery_step/heal/proc/get_progress(mob/user, mob/living/carbon/target, brute_healed, burn_healed)
	return

/datum/surgery_step/heal/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/woundtype
	if(brutehealing && burnhealing)
		woundtype = "травмы"
	else if(brutehealing)
		woundtype = "раны"
	else //why are you trying to 0,0...?
		woundtype = "ожоги"
	if(istype(surgery,/datum/surgery/healing))
		var/datum/surgery/healing/the_surgery = surgery
		if(!the_surgery.antispam)
			display_results(
				user,
				target,
				span_notice("Вы пытаетесь залатать [woundtype] [target]."),
				span_notice("[user] пытается залатать [woundtype] [target]."),
				span_notice("[user] пытается залатать [woundtype] [target]."),
			)
		display_pain(target, "Ваши [woundtype] жутко щиплят!")

/datum/surgery_step/heal/initiate(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, try_to_fail = FALSE)
	if(!..())
		return
	while((brutehealing && target.getBruteLoss()) || (burnhealing && target.getFireLoss()))
		if(!..())
			break

/datum/surgery_step/heal/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/user_msg = "Успешно залечиваю часть травм [target]" //no period, add initial space to "addons"
	var/target_msg = "[user] успешно залечивает часть травм [target]" //see above
	var/brute_healed = brutehealing
	var/burn_healed = burnhealing
	if(target.stat == DEAD) //dead patients get way less additional heal from the damage they have.
		brute_healed += round((target.getBruteLoss() * (brute_multiplier * 0.2)),0.1)
		burn_healed += round((target.getFireLoss() * (burn_multiplier * 0.2)),0.1)
	else
		brute_healed += round((target.getBruteLoss() * brute_multiplier),0.1)
		burn_healed += round((target.getFireLoss() * burn_multiplier),0.1)
	if(!get_location_accessible(target, target_zone))
		brute_healed *= 0.55
		burn_healed *= 0.55
		user_msg += " настолько ловко, насколько это возможно, пока пациент в одежде"
		target_msg += " настолько ловко, насколько это возможно, пока пациент в одежде"
	target.heal_bodypart_damage(brute_healed,burn_healed)

	user_msg += get_progress(user, target, brute_healed, burn_healed)

	display_results(
		user,
		target,
		span_notice("[user_msg]."),
		span_notice("[target_msg]."),
		span_notice("[target_msg]."),
	)
	if(istype(surgery, /datum/surgery/healing))
		var/datum/surgery/healing/the_surgery = surgery
		the_surgery.antispam = TRUE
	return ..()

/datum/surgery_step/heal/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_warning("Осечка!"),
		span_warning("[user] промахивается!"),
		span_notice("[user] залечивает некоторые раны [target]."),
		target_detailed = TRUE,
	)
	var/brute_dealt = brutehealing * 0.8
	var/burn_dealt = burnhealing * 0.8
	brute_dealt += round((target.getBruteLoss() * (brute_multiplier * 0.5)),0.1)
	burn_dealt += round((target.getFireLoss() * (burn_multiplier * 0.5)),0.1)
	target.take_bodypart_damage(brute_dealt, burn_dealt, wound_bonus=CANT_WOUND)
	return FALSE

/***************************BRUTE***************************/
/datum/surgery/healing/brute
	name = "Лечение ран"

/datum/surgery/healing/brute/basic
	name = "Лечение ран (Базовое)"
	replaced_by = /datum/surgery/healing/brute/upgraded
	healing_step_type = /datum/surgery_step/heal/brute/basic
	desc = "Хирургическая процедура, включающая восстановление после полученных физических травм на базовом уровне. Немного эффективнее, если пациент имеет много повреждений."

/datum/surgery/healing/brute/upgraded
	name = "Лечение ран (Продвинутое)"
	replaced_by = /datum/surgery/healing/brute/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/brute/upgraded
	desc = "Хирургическая процедура, включающая восстановление после полученных физических травм на продвинутом уровне. Эффективнее, если пациент имеет много повреждений."

/datum/surgery/healing/brute/upgraded/femto
	name = "Лечение ран (Экспертное)"
	replaced_by = /datum/surgery/healing/combo/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/brute/upgraded/femto
	desc = "Хирургическая процедура, включающая восстановление после полученных физических травм на экспертном уровне. Заметно эффективнее, если пациент имеет много повреждений."

/********************BRUTE STEPS********************/
/datum/surgery_step/heal/brute/get_progress(mob/user, mob/living/carbon/target, brute_healed, burn_healed)
	if(!brute_healed)
		return

	var/estimated_remaining_steps = target.getBruteLoss() / brute_healed
	var/progress_text

	if(locate(/obj/item/healthanalyzer) in user.held_items)
		progress_text = ". Оставшиеся повреждения: <font color='#ff3333'>[target.getBruteLoss()]</font>"
	else
		switch(estimated_remaining_steps)
			if(-INFINITY to 1)
				return
			if(1 to 3)
				progress_text = ", зашивает последние царапины"
			if(3 to 6)
				progress_text = ", постепенно сокращает количество отсавшихся ран"
			if(6 to 9)
				progress_text = ", продолжает ковыряться в болезненных разрывах"
			if(9 to 12)
				progress_text = ", морально готовится к длине предстоящей операции"
			if(12 to 15)
				progress_text = ", это выглядит больше как отбивная, нежели что-то живое"
			if(15 to INFINITY)
				progress_text = ", кажется, что прогресса в настолько травмированном теле добиться будет непросто"

	return progress_text

/datum/surgery_step/heal/brute/basic
	name = "залечить травмы (зажим)"
	brutehealing = 5
	brute_multiplier = 0.07

/datum/surgery_step/heal/brute/upgraded
	brutehealing = 5
	brute_multiplier = 0.1

/datum/surgery_step/heal/brute/upgraded/femto
	brutehealing = 5
	brute_multiplier = 0.2

/***************************BURN***************************/
/datum/surgery/healing/burn
	name = "Лечение ожогов"

/datum/surgery/healing/burn/basic
	name = "Лечение ожогов (Базовое)"
	replaced_by = /datum/surgery/healing/burn/upgraded
	healing_step_type = /datum/surgery_step/heal/burn/basic
	desc = "Хирургическая процедура, включающая восстановление после полученных ожогов на базовом уровне. Немного эффективнее, если пациент имеет много повреждений."

/datum/surgery/healing/burn/upgraded
	name = "Лечение ожогов (Продвинутое)"
	replaced_by = /datum/surgery/healing/burn/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/burn/upgraded
	desc = "Хирургическая процедура, включающая восстановление после полученных ожогов на продвинутом уровне. Эффективнее, если пациент имеет много повреждений."

/datum/surgery/healing/burn/upgraded/femto
	name = "Лечение ожогов (Экспертное)"
	replaced_by = /datum/surgery/healing/combo/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/burn/upgraded/femto
	desc = "Хирургическая процедура, включающая восстановление после полученных ожогов на экспертном уровне. Заметно эффективнее, если пациент имеет много повреждений."

/********************BURN STEPS********************/
/datum/surgery_step/heal/burn/get_progress(mob/user, mob/living/carbon/target, brute_healed, burn_healed)
	if(!burn_healed)
		return
	var/estimated_remaining_steps = target.getFireLoss() / burn_healed
	var/progress_text

	if(locate(/obj/item/healthanalyzer) in user.held_items)
		progress_text = ". Оставшиеся ожоги: <font color='#ff9933'>[target.getFireLoss()]</font>"
	else
		switch(estimated_remaining_steps)
			if(-INFINITY to 1)
				return
			if(1 to 3)
				progress_text = ", заканчивает с последними отметинами"
			if(3 to 6)
				progress_text = ", постепенно избавляется от омертвевшей кожи"
			if(6 to 9)
				progress_text = ", продолжает ковыряться со следами жара"
			if(9 to 12)
				progress_text = ", морально готовится к длине предстоящей операции"
			if(12 to 15)
				progress_text = ", это выглядит больше как сгоревший стейк, нежели что-то живое"
			if(15 to INFINITY)
				progress_text = ", кажется, что прогресса в настолько сожжёном теле добиться будет непросто"

	return progress_text

/datum/surgery_step/heal/burn/basic
	name = "залечить ожоги (зажим)"
	burnhealing = 5
	burn_multiplier = 0.07

/datum/surgery_step/heal/burn/upgraded
	burnhealing = 5
	burn_multiplier = 0.1

/datum/surgery_step/heal/burn/upgraded/femto
	burnhealing = 5
	burn_multiplier = 0.2

/***************************COMBO***************************/
/datum/surgery/healing/combo


/datum/surgery/healing/combo
	name = "Лечение травм (Смешанное, Базовое)"
	replaced_by = /datum/surgery/healing/combo/upgraded
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/combo
	desc = "Хирургическая процедура, включающая восстановление после полученных ран и ожогов на базовом уровне. Немного эффективнее, если пациент имеет много повреждений."

/datum/surgery/healing/combo/upgraded
	name = "Лечение травм (Смешанное, Продвинутое)"
	replaced_by = /datum/surgery/healing/combo/upgraded/femto
	healing_step_type = /datum/surgery_step/heal/combo/upgraded
	desc = "Хирургическая процедура, включающая восстановление после полученных ран и ожогов на продвинутом уровне. Немного эффективнее, если пациент имеет много повреждений."


/datum/surgery/healing/combo/upgraded/femto //no real reason to type it like this except consistency, don't worry you're not missing anything
	name = "Лечение травм (Смешанное, Экспертное)"
	replaced_by = null
	healing_step_type = /datum/surgery_step/heal/combo/upgraded/femto
	desc = "Хирургическая процедура, включающая восстановление после полученных ран и ожогов на экспертном уровне. Немного эффективнее, если пациент имеет много повреждений."

/********************COMBO STEPS********************/
/datum/surgery_step/heal/combo/get_progress(mob/user, mob/living/carbon/target, brute_healed, burn_healed)
	var/estimated_remaining_steps = 0
	if(brute_healed > 0)
		estimated_remaining_steps = max(0, (target.getBruteLoss() / brute_healed))
	if(burn_healed > 0)
		estimated_remaining_steps = max(estimated_remaining_steps, (target.getFireLoss() / burn_healed)) // whichever is higher between brute or burn steps

	var/progress_text

	if(locate(/obj/item/healthanalyzer) in user.held_items)
		if(target.getBruteLoss())
			progress_text = ". Оставшиеся раны: <font color='#ff3333'>[target.getBruteLoss()]</font>"
		if(target.getFireLoss())
			progress_text += ". Оставшиеся ожоги: <font color='#ff9933'>[target.getFireLoss()]</font>"
	else
		switch(estimated_remaining_steps)
			if(-INFINITY to 1)
				return
			if(1 to 3)
				progress_text = ", заканчивает с последними признаками повреждений"
			if(3 to 6)
				progress_text = ", избавляется от последних травмированных участков"
			if(6 to 9)
				progress_text = ", продолжает ковыряться с тяжёлыми травмами на теле"
			if(9 to 12)
				progress_text = ", морально готовится к длине предстоящей операции"
			if(12 to 15)
				progress_text = ", пока что это выглядит больше как труха, нежели что-то живое"
			if(15 to INFINITY)
				progress_text = ", кажется, что прогресса в настолько изувеченном теле добиться будет непросто"

	return progress_text

/datum/surgery_step/heal/combo
	name = "залечить физические раны (зажим)"
	brutehealing = 3
	burnhealing = 3
	brute_multiplier = 0.07
	burn_multiplier = 0.07
	time = 10

/datum/surgery_step/heal/combo/upgraded
	brutehealing = 3
	burnhealing = 3
	brute_multiplier = 0.1
	burn_multiplier = 0.1

/datum/surgery_step/heal/combo/upgraded/femto
	brutehealing = 1
	burnhealing = 1
	brute_multiplier = 0.4
	burn_multiplier = 0.4

/datum/surgery_step/heal/combo/upgraded/femto/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_warning("Осечка!"),
		span_warning("[user] промахивается!"),
		span_notice("[user] постепенно избавляется от ран [target]."),
		target_detailed = TRUE,
	)
	target.take_bodypart_damage(5,5)
