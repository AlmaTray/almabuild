/datum/surgery/core_removal
	name = "Удаление ядра"
	target_mobtypes = list(/mob/living/simple_animal/slime)
	surgery_flags = SURGERY_IGNORE_CLOTHES
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
	)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/extract_core,
	)

/datum/surgery/core_removal/can_start(mob/user, mob/living/target)
	if(target.stat == DEAD)
		return TRUE
	return FALSE

//extract brain
/datum/surgery_step/extract_core
	name = "вынуть ядро (зажим/лом)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_CROWBAR = 100)
	time = 16

/datum/surgery_step/extract_core/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете извлекать ядро [target]..."),
		span_notice("[user] начинает извлекать ядро [target]."),
		span_notice("[user] начинает извлекать ядро [target]."),
	)

/datum/surgery_step/extract_core/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/mob/living/simple_animal/slime/target_slime = target
	if(target_slime.cores > 0)
		target_slime.cores--
		display_results(
			user,
			target,
			span_notice("Вы успешно извлекаете ядро [target]. Ядер осталось: [target_slime.cores]."),
			span_notice("[user] успешно извлекает ядро [target]!"),
			span_notice("[user] успешно извлекает ядро [target]!"),
		)

		new target_slime.coretype(target_slime.loc)

		if(target_slime.cores <= 0)
			target_slime.icon_state = "[target_slime.colour] baby slime dead-nocore"
			return ..()
		else
			return FALSE
	else
		to_chat(user, span_warning("[target] больше не имеет ядер!"))
		return ..()
