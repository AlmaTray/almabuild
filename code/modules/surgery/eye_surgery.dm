/datum/surgery/eye_surgery
	name = "Глазная хирургия"
	requires_bodypart_type = NONE
	organ_to_manipulate = ORGAN_SLOT_EYES
	possible_locs = list(BODY_ZONE_PRECISE_EYES)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/fix_eyes,
		/datum/surgery_step/close,
	)

//fix eyes
/datum/surgery_step/fix_eyes
	name = "исправить глаза (зажим)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCREWDRIVER = 45,
		/obj/item/pen = 25)
	time = 64

/datum/surgery/eye_surgery/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/internal/eyes/target_eyes = target.getorganslot(ORGAN_SLOT_EYES)
	if(!target_eyes)
		to_chat(user, span_warning("Тяжело будет провести операцию на глазах у того, у кого их нет."))
		return FALSE
	return TRUE

/datum/surgery_step/fix_eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете исправлять глаза [target]..."),
		span_notice("[user] начинает исправлять глаза [target]."),
		span_notice("[user] проводит операцию на глазах [target]."),
	)
	display_pain(target, "Вы чувствуете режущую боль в глазах!")

/datum/surgery_step/fix_eyes/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/obj/item/organ/internal/eyes/target_eyes = target.getorganslot(ORGAN_SLOT_EYES)
	user.visible_message(span_notice("[user] успешно исправляет глаза [target]!"), span_notice("Вы успешно исправляете глаза [target]."))
	display_results(
		user,
		target,
		span_notice("Вы успешно исправляете глаза [target]."),
		span_notice("[user] успешно исправляет глаза [target]!"),
		span_notice("[user] завершает операцию на глазах [target]."),
	)
	display_pain(target, "Ваше зрение мутновато, но теперь, кажется, видно чуть лучше!")
	target.remove_status_effect(/datum/status_effect/temporary_blindness)
	target.set_eye_blur_if_lower(70 SECONDS) //this will fix itself slowly.
	target_eyes.setOrganDamage(0) // heals nearsightedness and blindness from eye damage
	return ..()

/datum/surgery_step/fix_eyes/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.getorgan(/obj/item/organ/internal/brain))
		display_results(
			user,
			target,
			span_warning("Вы случайно попадаете [target] прямо в мозг!"),
			span_warning("[user] случайно попадает [target] прямо в мозг!"),
			span_warning("[user] случайно попадает [target] прямо в мозг!"),
		)
		display_pain(target, "You feel a visceral stabbing pain right through your head, into your brain!")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 70)
	else
		display_results(
			user,
			target,
			span_warning("Вы случайно попадаете [target] прямо в мозг! Или попали бы, если бы у [target] был мозг."),
			span_warning("[user] случайно попадает [target] прямо в мозг! Ну, или не попадает. У [target] нет мозга.."),
			span_warning("[user] случайно попадает [target] прямо в мозг!"),
		)
		display_pain(target, "Вы чувствуете глубочайшую боль, проходящую через вашу голову!") // dunno who can feel pain w/o a brain but may as well be consistent.
	return FALSE
