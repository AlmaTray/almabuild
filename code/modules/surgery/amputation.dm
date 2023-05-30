/datum/surgery/amputation
	name = "Ампутация"
	requires_bodypart_type = NONE
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
		BODY_ZONE_HEAD,
	)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/sever_limb,
	)
	removes_target_bodypart = TRUE // SKYRAT EDIT ADDITION - Surgically unremovable limbs


/datum/surgery_step/sever_limb
	name = "распилить кость (циркулярная пила)"
	implements = list(
		/obj/item/shears = 300,
		TOOL_SCALPEL = 100,
		TOOL_SAW = 100,
		/obj/item/melee/arm_blade = 80,
		/obj/item/fireaxe = 50,
		/obj/item/hatchet = 40,
		/obj/item/knife/butcher = 25)
	time = 64
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/sever_limb/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете пилить кость в [parse_zone(target_zone)] [target]..."),
		span_notice("[user] начинает пилить кость в [parse_zone(target_zone)] [target]!"),
		span_notice("[user] начинает пилить кость в [parse_zone(target_zone)] [target]!"),
	)
	display_pain(target, "Сустав в [parse_zone(target_zone)] жутко болит!")


/datum/surgery_step/sever_limb/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("Вы закончили распиливать кость в [parse_zone(target_zone)] [target]."),
		span_notice("[user] заканчивает пилить кость в [parse_zone(target_zone)] [target]!"),
		span_notice("[user] заканчивает пилить кость в [parse_zone(target_zone)] [target]!"),
	)
	display_pain(target, "Вы больше не чувствуете вашу распиленную [parse_zone(target_zone)]!")
	if(surgery.operated_bodypart)
		var/obj/item/bodypart/target_limb = surgery.operated_bodypart
		target_limb.drop_limb()
	return ..()
