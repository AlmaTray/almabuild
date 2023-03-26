/datum/mood_event/drunk
	mood_change = 3
	description = "Everything just feels better after a drink or two."

/datum/mood_event/drunk/add_effects(param)
	// Display blush visual
	ADD_TRAIT(owner, TRAIT_BLUSHING, "[type]")
	owner.update_body()

/datum/mood_event/drunk/remove_effects()
	// Stop displaying blush visual
	REMOVE_TRAIT(owner, TRAIT_BLUSHING, "[type]")
	owner.update_body()

/datum/mood_event/quality_nice
	description = "Этот напиток был вполне неплох."
	mood_change = 2
	timeout = 7 MINUTES

/datum/mood_event/quality_good
	description = "Этот напиток был весьма хорош."
	mood_change = 4
	timeout = 7 MINUTES

/datum/mood_event/quality_verygood
	description = "Мне очень понравился этот напиток!"
	mood_change = 6
	timeout = 7 MINUTES

/datum/mood_event/quality_fantastic
	description = "Этот напиток просто прекрасен!"
	mood_change = 8
	timeout = 7 MINUTES

/datum/mood_event/amazingtaste
	description = "Еда была великолепной.."
	mood_change = 50
	timeout = 10 MINUTES

// SKYRAT ADD BEGIN
/datum/mood_event/race_drink
	description = "<span class='nicegreen'>Этот напиток создан для меня!</span>\n"
	mood_change = 12
	timeout = 9 MINUTES
//SKYRAT ADD END
