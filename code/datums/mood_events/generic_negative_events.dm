/datum/mood_event/handcuffed
	description = "Кажется, мне всё-таки придётся ответить за свои выходки."
	mood_change = -1

/datum/mood_event/broken_vow //Used for when mimes break their vow of silence
	description = "I have brought shame upon my name, and betrayed my fellow mimes by breaking our sacred vow..."
	mood_change = -8

/datum/mood_event/on_fire
	description = "Я ГОРЮ!!!"
	mood_change = -12

/datum/mood_event/suffocation
	description = "НЕ МОГУ... Д-ДЫШАТЬ..."
	mood_change = -12

/datum/mood_event/burnt_thumb
	description = "Не стоило мне играть с зажигалкой..."
	mood_change = -1
	timeout = 2 MINUTES

/datum/mood_event/cold
	description = "Тут слишком холодно."
	mood_change = -5

/datum/mood_event/hot
	description = "Тут слишком жарко."
	mood_change = -5

/datum/mood_event/creampie
	description = "Меня обсметанили. На вкус как пирог."
	mood_change = -2
	timeout = 3 MINUTES

/datum/mood_event/slipped
	description = "Как можно было подскользнуться?. Надо быть аккуратнее в следующий раз..."
	mood_change = -2
	timeout = 3 MINUTES

/datum/mood_event/eye_stab
	description = "Однажды и меня вела дорога приключений, пока мне не ткнули отвёрткой в глаз."
	mood_change = -4
	timeout = 3 MINUTES

/datum/mood_event/delam //SM delamination
	description = "Эти грёбаные инженеры никогда не научатся выполнять свою работу..."
	mood_change = -2
	timeout = 4 MINUTES

/datum/mood_event/cascade // Big boi delamination
	description = "Инженеры постарались окончательно, теперь мы все умрём..."
	mood_change = -8
	timeout = 5 MINUTES

/datum/mood_event/depression_minimal
	description = "Мне как-то не очень."
	mood_change = -10
	timeout = 2 MINUTES

/datum/mood_event/depression_mild
	description = "Мне грустно, не знаю почему."
	mood_change = -12
	timeout = 2 MINUTES

/datum/mood_event/depression_moderate
	description = "Меня настигло несчастье."
	mood_change = -14
	timeout = 2 MINUTES

/datum/mood_event/depression_severe
	description = "Я больше не могу.."
	mood_change = -16
	timeout = 2 MINUTES

/datum/mood_event/shameful_suicide //suicide_acts that return SHAME, like sord
	description = "Даже умереть достойно не могу!"
	mood_change = -15
	timeout = 60 SECONDS

/datum/mood_event/dismembered
	description = "ЭЭЙ! МНЕ ЕЩЁ НУЖНА ЭТА КОНЕЧНОСТЬ!"
	mood_change = -10
	timeout = 8 MINUTES

/datum/mood_event/tased
	description = "В \"тазере\" нет \"ш\". Это шок."
	mood_change = -3
	timeout = 2 MINUTES

/datum/mood_event/embedded
	description = "Выньте это из меня!"
	mood_change = -7

/datum/mood_event/table
	description = "Кто-то швырнул меня на стол!"
	mood_change = -2
	timeout = 2 MINUTES

/datum/mood_event/table/add_effects()
	if(isfelinid(owner)) //Holy snowflake batman!
		var/mob/living/carbon/human/H = owner
		SEND_SIGNAL(H, COMSIG_ORGAN_WAG_TAIL, TRUE, 3 SECONDS)
		description = "Кто-то хочет поиграть на столе!"
		mood_change = 2

/datum/mood_event/table_limbsmash
	description = "Ебучий стол, это очень больно..."
	mood_change = -3
	timeout = 3 MINUTES

/datum/mood_event/table_limbsmash/add_effects(obj/item/bodypart/banged_limb)
	if(banged_limb)
		description = "Блять, моя [banged_limb.plaintext_zone], почему так больно..."

/datum/mood_event/brain_damage
	mood_change = -3

/datum/mood_event/brain_damage/add_effects()
	var/damage_message = pick_list_replacements(BRAIN_DAMAGE_FILE, "brain_damage")
	description = "Хррф дрх... [damage_message]"

/datum/mood_event/hulk //Entire duration of having the hulk mutation
	description = "ХАЛК КРУШИТ!"
	mood_change = -4

/datum/mood_event/epilepsy //Only when the mutation causes a seizure
	description = "Нужно было обращать внимание на предупреждение об эпилепсии."
	mood_change = -3
	timeout = 5 MINUTES

/datum/mood_event/nyctophobia
	description = "Здесь достаточно темно..."
	mood_change = -3

/datum/mood_event/claustrophobia
	description = "Почему я чувствую себя в ловушке?! Выпустите меня!!!"
	mood_change = -7
	timeout = 1 MINUTES

/datum/mood_event/bright_light
	description = "Я ненавижу быть на свету... Мне нужно найти место потемнее..."
	mood_change = -12

/datum/mood_event/family_heirloom_missing
	description = "Мне так не хватает моей семейной реликвии..."
	mood_change = -4

/datum/mood_event/healsbadman
	description = "Я чувствую, что я на волоске, и могу сорваться в любой момент!"
	mood_change = -4
	timeout = 2 MINUTES

/datum/mood_event/jittery
	description = "Я на грани! Я нервничаю и не могу стоять нормально!!"
	mood_change = -2

/datum/mood_event/choke
	description = "Я НЕ МОГУ ДЫШАТЬ!!!"
	mood_change = -10

/datum/mood_event/vomit
	description = "Меня только что вырвало. Хреново."
	mood_change = -2
	timeout = 2 MINUTES

/datum/mood_event/vomitself
	description = "Меня вырвало прямо на себя. Это отвратительно."
	mood_change = -4
	timeout = 3 MINUTES

/datum/mood_event/painful_medicine
	description = "Лекарство может и лечит, но сейчас оно ужасно щиплет."
	mood_change = -5
	timeout = 60 SECONDS

/datum/mood_event/spooked
	description = "Звон тех костей... Он всё ещё преследует меня."
	mood_change = -4
	timeout = 4 MINUTES

/datum/mood_event/loud_gong
	description = "Этот звон действительно очень громкий, уши болят!"
	mood_change = -3
	timeout = 2 MINUTES

/datum/mood_event/notcreeping
	description = "Голоса недовольны. Они с болью искажают мои мысли, чтобы наконец заставить меня слушаться."
	mood_change = -6
	timeout = 3 SECONDS
	hidden = TRUE

/datum/mood_event/notcreepingsevere//not hidden since it's so severe
	description = "ИМ НУУУУУЖЕЕЕЕН КОНТРОООООЛЬ!!"
	mood_change = -30
	timeout = 3 SECONDS

/datum/mood_event/notcreepingsevere/add_effects(name)
	var/list/unstable = list(name)
	for(var/i in 1 to rand(3,5))
		unstable += copytext_char(name, -1)
	var/unhinged = uppertext(unstable.Join(""))//example Tinea Luxor > TINEA LUXORRRR (with randomness in how long that slur is)
	description = "ОНИИИИ ХОТЯЯЯЯТ [unhinged]!!"

/datum/mood_event/tower_of_babel
	description = "My ability to communicate is an incoherent babel..."
	mood_change = -1
	timeout = 15 SECONDS

/datum/mood_event/back_pain
	description = "Сумки никогда не сидят прямо на моей спине, это чертовски больно!"
	mood_change = -15

/datum/mood_event/sad_empath
	description = "Кому-то грустно..."
	mood_change = -1
	timeout = 60 SECONDS

/datum/mood_event/sad_empath/add_effects(mob/sadtarget)
	description = "[sadtarget.name], кажется, источает печаль..."

/datum/mood_event/sacrifice_bad
	description = "Проклятые дикари!"
	mood_change = -5
	timeout = 2 MINUTES

/datum/mood_event/artbad
	description = "Моя жопа производит более значимое искусство."
	mood_change = -2
	timeout = 2 MINUTES

/datum/mood_event/graverobbing
	description = "Осквернение могил - так себе идея... Не могу поверить, что я это делаю..."
	mood_change = -8
	timeout = 3 MINUTES

/datum/mood_event/deaths_door
	description = "Время пришло... Я и вправду умру."
	mood_change = -20

/datum/mood_event/gunpoint
	description = "Что за сумасшествие! Надо быть аккуратнее..."
	mood_change = -10

/datum/mood_event/tripped
	description = "Не могу поверить, что ведусь на этот древний трюк с книжкой!"
	mood_change = -5
	timeout = 2 MINUTES

/datum/mood_event/untied
	description = "Ненавижу развязывающиеся шнурки!"
	mood_change = -3
	timeout = 60 SECONDS

/datum/mood_event/gates_of_mansus
	description = "I HAD A GLIMPSE OF THE HORROR BEYOND THIS WORLD. REALITY UNCOILED BEFORE MY EYES!"
	mood_change = -25
	timeout = 4 MINUTES

/datum/mood_event/high_five_alone
	description = "Пытаться давать пять, когда рядом никого нет, довольно неловко!"
	mood_change = -2
	timeout = 60 SECONDS

/datum/mood_event/high_five_full_hand
	description = "Боже, я же даже не знаю как правильно дать пять..."
	mood_change = -1
	timeout = 45 SECONDS

/datum/mood_event/left_hanging
	description = "Всем ведь нравится давать пять! Может я просто кому-то... не нравлюсь?"
	mood_change = -2
	timeout = 90 SECONDS

/datum/mood_event/too_slow
	description = "НЕТ! ПОЧЕМУ НАСТОЛЬКО... НАСТОЛЬКО МЕДЛЕННО???"
	mood_change = -2 // multiplied by how many people saw it happen, up to 8, so potentially massive. the ULTIMATE prank carries a lot of weight
	timeout = 2 MINUTES

/datum/mood_event/too_slow/add_effects(param)
	var/people_laughing_at_you = 1 // start with 1 in case they're on the same tile or something
	for(var/mob/living/carbon/iter_carbon in oview(owner, 7))
		if(iter_carbon.stat == CONSCIOUS)
			people_laughing_at_you++
			if(people_laughing_at_you > 7)
				break

	mood_change *= people_laughing_at_you
	return ..()

//These are unused so far but I want to remember them to use them later
/datum/mood_event/surgery
	description = "МЕНЯ ВСКРЫВАЮТ ЖИВЬЁМ!!"
	mood_change = -8

/datum/mood_event/bald
	description = "Надо бы прикрыть лысину..."
	mood_change = -3

/datum/mood_event/bad_touch
	description = "Не люблю, когда люди меня трогают."
	mood_change = -3
	timeout = 4 MINUTES

/datum/mood_event/very_bad_touch
	description = "Мне очень не нравится, когда люди меня касаются."
	mood_change = -5
	timeout = 4 MINUTES

/datum/mood_event/noogie
	description = "Ow! This is like space high school all over again..."
	mood_change = -2
	timeout = 60 SECONDS

/datum/mood_event/noogie_harsh
	description = "OW!! That was even worse than a regular noogie!"
	mood_change = -4
	timeout = 60 SECONDS

/datum/mood_event/aquarium_negative
	description = "Все рыбки погибли..."
	mood_change = -3
	timeout = 90 SECONDS

/datum/mood_event/tail_lost
	description = "Мой хвост!! Но почему?!"
	mood_change = -8
	timeout = 10 MINUTES

/datum/mood_event/tail_balance_lost
	description = "Я теряю баланс без своего хвоста."
	mood_change = -2

/datum/mood_event/tail_regained_right
	description = "Мой хвост снова на месте, но это было травмирующе..."
	mood_change = -2
	timeout = 5 MINUTES

/datum/mood_event/tail_regained_wrong
	description = "Это какая-то шутка?! Это НЕ ТОТ хвост."
	mood_change = -12 // -8 for tail still missing + -4 bonus for being frakenstein's monster
	timeout = 5 MINUTES

/datum/mood_event/burnt_wings
	description = "МОИ КРЫЛЫШКИ!!"
	mood_change = -10
	timeout = 10 MINUTES

/datum/mood_event/holy_smite //punished
	description = "Божества покарали меня!"
	mood_change = -5
	timeout = 5 MINUTES

/datum/mood_event/banished //when the chaplain is sus! (and gets forcably de-holy'd)
	description = "Анафема! Меня отлучают от церкви!"
	mood_change = -10
	timeout = 10 MINUTES

/datum/mood_event/heresy
	description = "Я еле дышу из-за всей происходящей ЕРЕСИ!"
	mood_change = -5
	timeout = 5 MINUTES

/datum/mood_event/soda_spill
	description = "Круто! Всё в порядке, носить газировку - лучше чем пить..."
	mood_change = -2
	timeout = 1 MINUTES

/datum/mood_event/watersprayed
	description = "В меня брызнули водой!"
	mood_change = -1
	timeout = 30 SECONDS

//SKYRAT EDIT START: Mainly surgery for now.
/datum/mood_event/mild_surgery
	description = "<span class='warning'>Даже с учётом того, что я почти ничего не чувствую, очень неприятно просыпаться и видеть, как кто-то роется в моём теле. Агх!</span>\n"
	mood_change = -1
	timeout = 5 MINUTES

/datum/mood_event/severe_surgery
	description = "<span class='boldwarning'>Погоди, ОНИ ВСКРЫЛИ МЕНЯ - ЧУВСТВУЕТСЯ КАЖДОЕ ДВИЖЕНИЕ!</span>\n"
	mood_change = -4
	timeout = 15 MINUTES

/datum/mood_event/robot_surgery
	description = "<span class='warning'>Неприятно ощущать, как в моих комплектующих кто-то роется, пока я сознании... вот бы иметь режим сна!</span>\n"
	mood_change = -4
	timeout = 10 MINUTES
//SKYRAT EDIT END

/datum/mood_event/gamer_withdrawal
	description = "Лучше бы это было игрой..."
	mood_change = -5

/datum/mood_event/gamer_lost
	description = "Я фигово играю в видеоигры, могу ли я называть себя геймером?"
	mood_change = -10
	timeout = 10 MINUTES

/datum/mood_event/lost_52_card_pickup
	description = "Как неловко! Стыдно собирать все эти карты с пола..."
	mood_change = -3
	timeout = 3 MINUTES

/datum/mood_event/russian_roulette_lose
	description = "Ставка в жизнь проиграна! Полагаю, это конец..."
	mood_change = -20
	timeout = 10 MINUTES

/datum/mood_event/bad_touch_bear_hug
	description = "Меня слишком сильно приобняли."
	mood_change = -1
	timeout = 2 MINUTES

/datum/mood_event/rippedtail
	description = "Мой хвост вырван, что же я творю!"
	mood_change = -5
	timeout = 30 SECONDS

/datum/mood_event/sabrage_fail
	description = "Чёрт! Трюк пошёл не по плану!"
	mood_change = -2
	timeout = 4 MINUTES

/datum/mood_event/body_purist
	description = "Я чувствую, как ко мне присоединяют кибернетику, мне это НЕ НРАВИТСЯ!"

/datum/mood_event/body_purist/add_effects(power)
	mood_change = power

/datum/mood_event/unsatisfied_nomad
	description = "Долго я тут сижу! Надо-бы вылететь в космос навстречу приключениям!"
	mood_change = -3
