/datum/language/narsie
	name = "Наречие Нар'Си"
	desc = "Древний, пропитанный кровью, невыносимо сложный язык культистов Нар'Си."
	key = "n"
	sentence_chance = 8
	space_chance = 95 //very high due to the potential length of each syllable
	var/static/list/base_syllables = list(
		"х", "в", "ц", "е", "г", "д", "р", "н", "х", "о", "п",
		"па", "ко", "ам", "ил", "ма", "ғ", "ш", "я", "те", "ш", "ол", "ма", "ом", "иг", "ни", "ин",
		"ша", "мир", "сас", "ма", "зар", "ток", "лыр", "нғя", "нап", "олт", "вал", "ғха",
		"фўе", "ат", "иро", "эт", "гал", "гиб", "бар", "чжин", "кла", "ату", "кал", "лиг",
		"ёка", "драк", "лосо", "арта", "ўейх", "инес", "тот", "фара", "амар", "нъяг", "эске", "реѳ", "дэдо", "бтоо", "никт", "нэт",
		"канас", "гарис", "улофт", "тарат", "кхари", "ѳнор", "рэкка", "рагга", "рфикк", "харфр", "андид", "этра", "дэдол", "тотум",
		"нтара", "кериам"
	) //the list of syllables we'll combine with itself to get a larger list of syllables
	syllables = list(
		"ша", "мир", "сас", "мах", "хра", "зар", "ток", "лыр", "нғя", "нап", "олт", "вал",
		"йам", "ғха", "фел", "дет", "фўэ", "мах", "ерл", "ат", "ыро", "этт", "гал", "муд",
		"гиб", "бар", "тээ", "фуу", "чжин", "кла", "ату", "кал", "лиг",
		"йока", "драк", "лосо", "арта", "ўэйх", "инэс", "тот", "фара", "амар", "нъяг", "эске", "рет", "дедо", "бтоо", "никт", "нэт", "абис",
		"канас", "гарис", "улофт", "тарат", "кхари", "ѳнор", "рэкка", "рагга", "рфикк", "харфр", "андид", "этра", "дедол", "тотум",
		"вербо", "плегх", "нтра", "бархаа", "паснар", "кериам", "юсинар", "саврэ", "амутан", "таннин", "рэмиум", "бараада",
		"форбичи"
	) //the base syllables, which include a few rare ones that won't appear in the mixed syllables
	icon_state = "narsie"
	default_priority = 10

/datum/language/narsie/New()
	for(var/syllable in base_syllables) //we only do this once, since there's only ever a single one of each language datum.
		for(var/target_syllable in base_syllables)
			if(syllable != target_syllable) //don't combine with yourself
				if(length(syllable) + length(target_syllable) > 8) //if the resulting syllable would be very long, don't put anything between it
					syllables += "[syllable][target_syllable]"
				else if(prob(80)) //we'll be minutely different each round.
					syllables += "[syllable]'[target_syllable]"
				else if(prob(25)) //5% chance of - instead of '
					syllables += "[syllable]-[target_syllable]"
				else //15% chance of no ' or - at all
					syllables += "[syllable][target_syllable]"
	..()
