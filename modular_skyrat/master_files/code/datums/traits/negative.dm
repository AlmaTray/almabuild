// SKYRAT NEGATIVE TRAITS

/datum/quirk/alexithymia
	name = "Alexithymia"
	desc = "Вы не можете точно оценить свои чувства."
	value = -4
	mob_trait = TRAIT_MOOD_NOEXAMINE
	medical_record_text = "Пациент не способен передавать свои эмоции."
	icon = "question-circle"

/datum/quirk/fragile
	name = "Fragility"
	desc = "Вы чувствуете себя невероятно хрупким. Ожоги и синяки причиняют вам больше боли, чем обычно!"
	value = -6
	medical_record_text = "Тело пациента адаптировалось к низкой гравитации. К сожалению, условия с низкой гравитацией не способствуют развитию крепких костей."
	icon = "tired"

/datum/quirk/fragile/post_add()
	. = ..()
	var/mob/living/carbon/human/user = quirk_holder
	user.physiology.brute_mod *= 1.25
	user.physiology.burn_mod *= 1.2

/datum/quirk/fragile/remove()
	. = ..()
	var/mob/living/carbon/human/user = quirk_holder
	user.physiology.brute_mod /= 1.25
	user.physiology.burn_mod /= 1.2

/datum/quirk/monophobia
	name = "Monophobia"
	desc = "Вы будете испытывать все больший стресс, когда не находитесь в компании других людей, вызывая панические реакции, начиная от тошноты и заканчивая сердечными приступами."
	value = -6
	gain_text = span_danger("Вы чувствуете себя очень одиноко...")
	lose_text = span_notice("Вы чувствуете, что в безопасности и в одиночку.")
	medical_record_text = "Пациент чувствует себя плохо и нервозно, когда рядом нет других людей, что приводит к потенциально смертельному уровню стресса."
	icon = "people-arrows"

/datum/quirk/monophobia/post_add()
	. = ..()
	var/mob/living/carbon/human/user = quirk_holder
	user.gain_trauma(/datum/brain_trauma/severe/monophobia, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/monophobia/remove()
	. = ..()
	var/mob/living/carbon/human/user = quirk_holder
	user?.cure_trauma_type(/datum/brain_trauma/severe/monophobia, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/ashwalkertalons
	name = "Chunky Fingers"
	desc = "Ваши пальцы толстые и жесткие и не позволяют использовать модульные компьютеры, включая планшеты, некоторые устройства, такие как лазерные указки, и неадаптированное огнестрельное оружие."
	gain_text = span_notice("Ваши пальцы кажутся толще и немного менее ловкими. Вы ожидаете, что вам будет трудно пользоваться компьютерами, некоторыми небольшими устройствами и огнестрельным оружием")
	lose_text = span_notice("Ваши пальцы снова чувствуют себя гибкими и дееспособными.")
	medical_record_text = "Пальцы пациента толстые, и им не хватает ловкости для управления некоторыми небольшими устройствами, компьютерами и неадаптированным огнестрельным оружием."
	value = -8
	mob_trait = TRAIT_CHUNKYFINGERS
	icon = "hand-middle-finger"

/datum/quirk/no_guns
	name = "No Guns"
	desc = "По какой-либо причине вы не можете использовать дальнобойное оружие. По какой, решать уже вам."
	gain_text = span_notice("Вы чувствуете, что больше не сможете стрелять...")
	lose_text = span_notice("Вы вдруг чувствуют, что снова можете стрелять!")
	medical_record_text = "Пациент не может использовать огнестрельное оружие. Причины неизвестны."
	value = -6
	mob_trait = TRAIT_NOGUNS
	icon = "none"
