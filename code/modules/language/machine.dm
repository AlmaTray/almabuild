/datum/language/machine
	name = "Зашифрованный аудиоязык"
	desc = "Эффективный способ коммуникаций синтетиков и киборгов, использующий специальные частоты."
	spans = list(SPAN_ROBOT)
	key = "6"
	flags = NO_STUTTER
	syllables = list("бип","бип","бип","бип","бип","бип","буп","буп","бап","bаp","ди","ди","ду","ду","пшш","хсс","бзз","бзз","бз","кшшш","кии","ўурр","ўаа","тззз")
	space_chance = 10
	default_priority = 90

	icon_state = "eal"

/datum/language/machine/get_random_name()
	if(prob(70))
		return "[pick(GLOB.posibrain_names)]-[rand(100, 999)]"
	return pick(GLOB.ai_names)
