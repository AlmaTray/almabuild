/datum/surgery/brain_surgery
	name = "Нейрохирургия"
	possible_locs = list(BODY_ZONE_HEAD)
	requires_bodypart_type = NONE
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/fix_brain,
		/datum/surgery_step/close,
	)

/datum/surgery_step/fix_brain
	name = "исправить мозг (зажим)"
	implements = list(
		TOOL_HEMOSTAT = 85,
		TOOL_SCREWDRIVER = 35,
		/obj/item/pen = 15) //don't worry, pouring some alcohol on their open brain will get that chance to 100
	repeatable = TRUE
	time = 100 //long and complicated
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/hemostat1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery/brain_surgery/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/internal/brain/target_brain = target.getorganslot(ORGAN_SLOT_BRAIN)
	if(!target_brain)
		return FALSE
	return TRUE

/datum/surgery_step/fix_brain/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете исправлять мозг [target]..."),
		span_notice("[user] начинает исправлять мозг [target]."),
		span_notice("[user] начинает оперировать мозг [target]."),
	)
	display_pain(target, "В голову ударила невообразимая боль!")

/datum/surgery_step/fix_brain/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("Вы успешно исправляете мозг [target]."),
		span_notice("[user] успешно исправляет мозг [target]!"),
		span_notice("[user] завершает операцию на мозге [target]."),
	)
	display_pain(target, "Боль в голове отступает, думать становится чуть проще..")
	if(target.mind?.has_antag_datum(/datum/antagonist/brainwashed))
		target.mind.remove_antag_datum(/datum/antagonist/brainwashed)
	target.setOrganLoss(ORGAN_SLOT_BRAIN, target.getOrganLoss(ORGAN_SLOT_BRAIN) - 50) //we set damage in this case in order to clear the "failing" flag
	target.cure_all_traumas(TRAUMA_RESILIENCE_SURGERY)
	if(target.getOrganLoss(ORGAN_SLOT_BRAIN) > 0)
		to_chat(user, "Мозг [target] выглядит исправленным не до конца.")
	return ..()

/datum/surgery_step/fix_brain/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.getorganslot(ORGAN_SLOT_BRAIN))
		display_results(
			user,
			target,
			span_warning("Вы проваливаете этап, нанося больший ущерб!"),
			span_warning("[user] допускает осечку, нанося мозгу дополнителный ущерб!"),
			span_notice("[user] завершает операцию на мозге [target]."),
		)
		display_pain(target, "Ваша голова ужасно пульсирует, думать становится больно!")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 60)
		target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	else
		user.visible_message(span_warning("[user] внезапно осознаёт, что мозга в теле пациента больше нет на месте."), span_warning("Вы внезапно осознаёте то, что мозг, над которым вы работали, больше не в теле пациента."))
	return FALSE
