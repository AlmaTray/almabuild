
/////BONE FIXING SURGERIES//////

///// Repair Hairline Fracture (Severe)
/datum/surgery/repair_bone_hairline
	name = "Восстановление костной структуры (трещина)"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	targetable_wound = /datum/wound/blunt/severe
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
		/datum/surgery_step/repair_bone_hairline,
		/datum/surgery_step/close,
	)

/datum/surgery/repair_bone_hairline/can_start(mob/living/user, mob/living/carbon/target)
	. = ..()
	if(.)
		var/obj/item/bodypart/targeted_bodypart = target.get_bodypart(user.zone_selected)
		return(targeted_bodypart.get_wound_type(targetable_wound))


///// Repair Compound Fracture (Critical)
/datum/surgery/repair_bone_compound
	name = "Исправление тяжёлого перелома"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	targetable_wound = /datum/wound/blunt/critical
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
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/reset_compound_fracture,
		/datum/surgery_step/repair_bone_compound,
		/datum/surgery_step/close,
	)

/datum/surgery/repair_bone_compound/can_start(mob/living/user, mob/living/carbon/target)
	. = ..()
	if(.)
		var/obj/item/bodypart/targeted_bodypart = target.get_bodypart(user.zone_selected)
		return(targeted_bodypart.get_wound_type(targetable_wound))

//SURGERY STEPS

///// Repair Hairline Fracture (Severe)
/datum/surgery_step/repair_bone_hairline
	name = "восстановить структуру кости (костоправ/костный гель/хирург. лента)"
	implements = list(
		/obj/item/bonesetter = 100,
		/obj/item/stack/medical/bone_gel = 100,
		/obj/item/stack/sticky_tape/surgical = 100,
		/obj/item/stack/sticky_tape/super = 50,
		/obj/item/stack/sticky_tape = 30)
	time = 40

/datum/surgery_step/repair_bone_hairline/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.operated_wound)
		display_results(
			user,
			target,
			span_notice("Вы начинаете восстанавливать костную структуру [parse_zone(user.zone_selected)] [target]..."),
			span_notice("[user] начинает восстанавливать костную струкуру [parse_zone(user.zone_selected)] [target] при помощи [tool]."),
			span_notice("[user] начинает восстанавливать костную струкуру [parse_zone(user.zone_selected)] [target]."),
		)
		display_pain(target, "Ваша [parse_zone(user.zone_selected)] ноет от боли!")
	else
		user.visible_message(span_notice("[user] упорно ищет [parse_zone(user.zone_selected)] у [target]."), span_notice("Вы упорно ищете [parse_zone(user.zone_selected)] у [target]..."))

/datum/surgery_step/repair_bone_hairline/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(surgery.operated_wound)
		if(isstack(tool))
			var/obj/item/stack/used_stack = tool
			used_stack.use(1)
		display_results(
			user,
			target,
			span_notice("Вы успешно восстанавливаете костную структуру в [parse_zone(target_zone)] [target]."),
			span_notice("[user] успешно восстанавливает костную структуру [parse_zone(target_zone)] [target] при помощи [tool]!"),
			span_notice("[user] успешно восстанавливает костную структуру [parse_zone(target_zone)] [target]"),
		)
		log_combat(user, target, "чинит костную структуру", addition="COMBAT_MODE: [uppertext(user.combat_mode)]")
		qdel(surgery.operated_wound)
	else
		to_chat(user, span_warning("[target] не имеет костей в этом месте!"))
	return ..()

/datum/surgery_step/repair_bone_hairline/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	if(isstack(tool))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)



///// Reset Compound Fracture (Crticial)
/datum/surgery_step/reset_compound_fracture
	name = "вправить кость (костоправ)"
	implements = list(
		/obj/item/bonesetter = 100,
		/obj/item/stack/sticky_tape/surgical = 60,
		/obj/item/stack/sticky_tape/super = 40,
		/obj/item/stack/sticky_tape = 20)
	time = 40

/datum/surgery_step/reset_compound_fracture/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.operated_wound)
		display_results(
			user,
			target,
			span_notice("Вы начинаете вправлять кость в [parse_zone(user.zone_selected)] [target]..."),
			span_notice("[user] начинает вправлять кость в [parse_zone(user.zone_selected)] [target] при помощи [tool]."),
			span_notice("[user] начинает вправлять кость в [parse_zone(user.zone_selected)] [target]."),
		)
		display_pain(target, "Ноющая боль в [parse_zone(user.zone_selected)] жутко раздражает!")
	else
		user.visible_message(span_notice("[user] пытается найти [parse_zone(user.zone_selected)] у [target]."), span_notice("Вы ищете [parse_zone(user.zone_selected)] у [target]..."))

/datum/surgery_step/reset_compound_fracture/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(surgery.operated_wound)
		if(isstack(tool))
			var/obj/item/stack/used_stack = tool
			used_stack.use(1)
		display_results(
			user,
			target,
			span_notice("Вы успешно вправляете кость в [parse_zone(user.zone_selected)] [target]."),
			span_notice("[user] успешно вправляет кость в [parse_zone(user.zone_selected)] [target] при помощи [tool]!"),
			span_notice("[user] успешно вправляет кость в [parse_zone(user.zone_selected)] [target]!"),
		)
		log_combat(user, target, "восстанавливает структуру кости", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
	else
		to_chat(user, span_warning("[target] не имеет костей в этом месте!"))
	return ..()

/datum/surgery_step/reset_compound_fracture/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	if(isstack(tool))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)


///// Repair Compound Fracture (Crticial)
/datum/surgery_step/repair_bone_compound
	name = "восстановить костную структуру (костный гель/хирург. лента)"
	implements = list(
		/obj/item/stack/medical/bone_gel = 100,
		/obj/item/stack/sticky_tape/surgical = 100,
		/obj/item/stack/sticky_tape/super = 50,
		/obj/item/stack/sticky_tape = 30)
	time = 40

/datum/surgery_step/repair_bone_compound/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.operated_wound)
		display_results(
			user,
			target,
			span_notice("Вы начинаете восстанавливать кость [parse_zone(user.zone_selected)] [target]..."),
			span_notice("[user] начинает восстанавливать кость в [parse_zone(user.zone_selected)] при помощи [tool]."),
			span_notice("[user] начинает восстанавливать кость в [parse_zone(user.zone_selected)]."),
		)
		display_pain(target, "Ноющая боль в [parse_zone(user.zone_selected)] жутко раздражает!")
	else
		user.visible_message(span_notice("[user] упорно ищет [parse_zone(user.zone_selected)] [target]."), span_notice("Вы ищете [target]'s [parse_zone(user.zone_selected)]..."))

/datum/surgery_step/repair_bone_compound/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(surgery.operated_wound)
		if(isstack(tool))
			var/obj/item/stack/used_stack = tool
			used_stack.use(1)
		display_results(
			user,
			target,
			span_notice("Вы успешно восстанавливаете кость в [parse_zone(user.zone_selected)] [target]."),
			span_notice("[user] успешно восстанавливает кость в [parse_zone(user.zone_selected)] [target] при помощи [tool]!"),
			span_notice("[user] успешно восстанавливает кость в [parse_zone(user.zone_selected)] [target]!"),
		)
		log_combat(user, target, "чинит перелом", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
		qdel(surgery.operated_wound)
	else
		to_chat(user, span_warning("[target] не имеет костей в этом месте!"))
	return ..()

/datum/surgery_step/repair_bone_compound/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	if(isstack(tool))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)
