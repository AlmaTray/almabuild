/datum/surgery/coronary_bypass
	name = "Коронарное шунтирование"
	organ_to_manipulate = ORGAN_SLOT_HEART
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise_heart,
		/datum/surgery_step/coronary_bypass,
		/datum/surgery_step/close,
	)

/datum/surgery/coronary_bypass/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/internal/heart/target_heart = target.getorganslot(ORGAN_SLOT_HEART)
	if(target_heart)
		if(target_heart.damage > 60 && !target_heart.operated)
			return TRUE
	return FALSE


//an incision but with greater bleed, and a 90% base success chance
/datum/surgery_step/incise_heart
	name = "надрезать сердце (скальпель)"
	implements = list(
		TOOL_SCALPEL = 90,
		/obj/item/melee/energy/sword = 45,
		/obj/item/knife = 45,
		/obj/item/shard = 25)
	time = 16
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/incise_heart/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете делать надрез в сердце [target]..."),
		span_notice("[user] начинает делать надрез в сердце [target]."),
		span_notice("[user] начинает делать надрез в сердце [target]."),
	)
	display_pain(target, "Вы чувствуете ужасающую боль в сердце, которой почти достаточно, чтобы потерять сознание!")

/datum/surgery_step/incise_heart/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		if (!HAS_TRAIT(target_human, TRAIT_NOBLOOD))
			display_results(
				user,
				target,
				span_notice("Кровь показывается вокруг надреза в сердце [target_human]."),
				span_notice("Кровь показывается вокруг надреза в сердце [target_human]."),
				span_notice("Кровь показывается вокруг надреза в сердце [target_human]."),
			)
			var/obj/item/bodypart/target_bodypart = target_human.get_bodypart(target_zone)
			target_bodypart.adjustBleedStacks(10)
			target_human.adjustBruteLoss(10)
	return ..()

/datum/surgery_step/incise_heart/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		display_results(
			user,
			target,
			span_warning("Вы промахиваетесь, прорезая сердце слишком глубоко!"),
			span_warning("[user] промахивается, заставляя струю крови вырываться из груди [target_human]!"),
			span_warning("[user] промахивается, заставляя струю крови вырываться из груди [target_human]!"),
		)
		var/obj/item/bodypart/target_bodypart = target_human.get_bodypart(target_zone)
		target_bodypart.adjustBleedStacks(10)
		target_human.adjustOrganLoss(ORGAN_SLOT_HEART, 10)
		target_human.adjustBruteLoss(10)

//grafts a coronary bypass onto the individual's heart, success chance is 90% base again
/datum/surgery_step/coronary_bypass
	name = "провести коронарное шунтирование (зажим)"
	implements = list(
		TOOL_HEMOSTAT = 90,
		TOOL_WIRECUTTER = 35,
		/obj/item/stack/package_wrap = 15,
		/obj/item/stack/cable_coil = 5)
	time = 90
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/hemostat1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/coronary_bypass/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Вы начинаете шунтировать сердце [target]..."),
		span_notice("[user] начинает вставлять что-то в сердце [target]!"),
		span_notice("[user] начинает вставлять что-то в сердце [target]!"),
	)
	display_pain(target, "Боль в груди просто невыносима! Я еле-еле это выношу!")

/datum/surgery_step/coronary_bypass/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	target.setOrganLoss(ORGAN_SLOT_HEART, 60)
	var/obj/item/organ/internal/heart/target_heart = target.getorganslot(ORGAN_SLOT_HEART)
	if(target_heart) //slightly worrying if we lost our heart mid-operation, but that's life
		target_heart.operated = TRUE
	display_results(
		user,
		target,
		span_notice("Вы успешно шунтируете сердце [target]."),
		span_notice("[user] заканчивает шунтировать сердце [target]."),
		span_notice("[user] заканчивает шунтировать сердце [target]."),
	)
	display_pain(target, "Боль пульсирует в груди, но сердцу стало лучше чем никогда!")
	return ..()

/datum/surgery_step/coronary_bypass/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/target_human = target
		display_results(
			user,
			target,
			span_warning("Вы неправильно поставили стент, из-за чего сердце царапается!"),
			span_warning("[user] неправильно устанавливает стент, из-за чего сердце [target_human] брызгает кровью!"),
			span_warning("[user] неправильно устанавливает стент, из-за чего сердце [target_human] брызгает кровью!"),
		)
		display_pain(target, "Грудь жжёт; вы чувствуете, что сходите с ума!")
		target_human.adjustOrganLoss(ORGAN_SLOT_HEART, 20)
		var/obj/item/bodypart/target_bodypart = target_human.get_bodypart(target_zone)
		target_bodypart.adjustBleedStacks(30)
	return FALSE
