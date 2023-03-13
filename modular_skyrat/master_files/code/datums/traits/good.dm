// SKYRAT GOOD TRAITS

/datum/quirk/hard_soles
	name = "Hardened Soles"
	desc = "Вы привыкли ходить босиком и более не получаете неудобств от этого."
	value = 2
	mob_trait = TRAIT_HARD_SOLES
	gain_text = span_notice("Земля более не ощущается такой грубой.")
	lose_text = span_danger("Вы начинаете ощущать выступы и несовершенства на земле.")
	medical_record_text = "Ступни пациента более устойчивы к повреждениям"
	icon = "boot"

/datum/quirk/linguist
	name = "Linguist"
	desc = "Вы изучали разные языки и хоршо знаете на один язык большеж"
	value = 4
	mob_trait = QUIRK_LINGUIST
	gain_text = span_notice("Ваш мозг, кажется, более приспособлен для разных способов разговора.")
	lose_text = span_danger("Ваше понимание тонкостей драконьих идиом исчезает.")
	medical_record_text = "Пациент демонстрирует высокую пластичность мозга в отношении изучения языка."
	icon = "globe"

// AdditionalEmotes *turf quirks
/datum/quirk/water_aspect
	name = "Water aspect (Emotes)"
	desc = "(Aquatic innate) Underwater societies are home to you, space ain't much different. (Say *turf to cast)"
	value = 0
	mob_trait = TRAIT_WATER_ASPECT
	gain_text = span_notice("You feel like you can control water.")
	lose_text = span_danger("Somehow, you've lost your ability to control water!")
	medical_record_text = "Patient holds a collection of nanobots designed to synthesize H2O."
	icon = "water"

/datum/quirk/webbing_aspect
	name = "Webbing aspect (Emotes)"
	desc = "(Insect innate) Insect folk capable of weaving aren't unfamiliar with receiving envy from those lacking a natural 3D printer. (Say *turf to cast)"
	value = 0
	mob_trait = TRAIT_WEBBING_ASPECT
	gain_text = span_notice("You could easily spin a web.")
	lose_text = span_danger("Somehow, you've lost your ability to weave.")
	medical_record_text = "Patient has the ability to weave webs with naturally synthesized silk."
	icon = "spider-web"

/datum/quirk/floral_aspect
	name = "Floral aspect (Emotes)"
	desc = "(Podperson innate) Kudzu research isn't pointless, rapid photosynthesis technology is here! (Say *turf to cast)"
	value = 0
	mob_trait = TRAIT_FLORAL_ASPECT
	gain_text = span_notice("You feel like you can grow vines.")
	lose_text = span_danger("Somehow, you've lost your ability to rapidly photosynthesize.")
	medical_record_text = "Patient can rapidly photosynthesize to grow vines."
	icon = "seedling"

/datum/quirk/ash_aspect
	name = "Ash aspect (Emotes)"
	desc = "(Lizard innate) The ability to forge ash and flame, a mighty power - yet mostly used for theatrics. (Say *turf to cast)"
	value = 0
	mob_trait = TRAIT_ASH_ASPECT
	gain_text = span_notice("There is a forge smouldering inside of you.")
	lose_text = span_danger("Somehow, you've lost your ability to breathe fire.")
	medical_record_text = "Patients possess a fire breathing gland commonly found in lizard folk."
	icon = "fire"

/datum/quirk/sparkle_aspect
	name = "Sparkle aspect (Emotes)"
	desc = "(Moth innate) Sparkle like the dust off of a moth's wing, or like a cheap red-light hook-up. (Say *turf to cast)"
	value = 0
	mob_trait = TRAIT_SPARKLE_ASPECT
	gain_text = span_notice("You're covered in sparkling dust!")
	lose_text = span_danger("Somehow, you've completely cleaned yourself of glitter..")
	medical_record_text = "Patient seems to be looking fabulous."
	icon = "hand-sparkles"
