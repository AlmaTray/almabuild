/datum/language_menu
	var/datum/language_holder/language_holder

/datum/language_menu/New(_language_holder)
	language_holder = _language_holder

/datum/language_menu/Destroy()
	language_holder = null
	. = ..()

/datum/language_menu/ui_state(mob/user)
	return GLOB.language_menu_state

/datum/language_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LanguageMenu")
		ui.open()

/datum/language_menu/ui_data(mob/user)
	var/list/data = list()

	var/atom/movable/AM = language_holder.get_atom()
	if(isliving(AM))
		data["is_living"] = TRUE
	else
		data["is_living"] = FALSE

	data["languages"] = list()
	for(var/lang in GLOB.all_languages)
		var/result = language_holder.has_language(lang) || language_holder.has_language(lang, TRUE)
		if(!result)
			continue
		var/datum/language/language = lang
		var/list/L = list()

		L["name"] = initial(language.name)
		L["desc"] = initial(language.desc)
		L["key"] = initial(language.key)
		L["is_default"] = (language == language_holder.selected_language)
		if(AM)
			L["can_speak"] = AM.can_speak_language(language)
			L["can_understand"] = AM.has_language(language)

		data["languages"] += list(L)

	if(check_rights_for(user.client, R_ADMIN) || isobserver(AM))
		data["admin_mode"] = TRUE
		data["omnitongue"] = language_holder.omnitongue

		data["unknown_languages"] = list()
		for(var/lang in GLOB.all_languages)
			if(language_holder.has_language(lang) || language_holder.has_language(lang, TRUE))
				continue
			var/datum/language/language = lang
			var/list/L = list()

			L["name"] = initial(language.name)
			L["desc"] = initial(language.desc)
			L["key"] = initial(language.key)

			data["unknown_languages"] += list(L)
	return data

/datum/language_menu/ui_act(action, params)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	var/atom/movable/AM = language_holder.get_atom()

	var/language_name = params["language_name"]
	var/datum/language/language_datum
	for(var/lang in GLOB.all_languages)
		var/datum/language/language = lang
		if(language_name == initial(language.name))
			language_datum = language
	var/is_admin = check_rights_for(user.client, R_ADMIN)

	switch(action)
		if("select_default")
			if(language_datum && AM.can_speak_language(language_datum))
				language_holder.selected_language = language_datum
				. = TRUE
		if("grant_language")
			if((is_admin || isobserver(AM)) && language_datum)
				var/list/choices = list("Возможность говорить", "Возможность понимать", "Оба")
				var/choice = tgui_input_list(user, "Как вы хотите добавить этот язык?", "[language_datum]", choices)
				if(isnull(choice))
					return
				var/spoken = FALSE
				var/understood = FALSE
				switch(choice)
					if("Возможность говорить")
						spoken = TRUE
					if("Возможность понимать")
						understood = TRUE
					if("Обе")
						spoken = TRUE
						understood = TRUE
				if(language_holder.blocked_languages && language_holder.blocked_languages[language_datum])
					choice = tgui_alert(user, "Снять блокировку, не поволяющую понимать и говорить на языке?", "[language_datum]", list("Да", "Нет"))
					if(choice == "Да")
						language_holder.remove_blocked_language(language_datum, LANGUAGE_ALL)
				language_holder.grant_language(language_datum, understood, spoken)
				if(is_admin)
					message_admins("[key_name_admin(user)] выдаёт язык [language_name] [key_name_admin(AM)].")
					log_admin("[key_name(user)] выдаёт [language_name] [key_name(AM)].")
				. = TRUE
		if("remove_language")
			if((is_admin || isobserver(AM)) && language_datum)
				var/list/choices = list("Возможность говорить", "Возможность понимать", "Обе")
				var/choice = tgui_input_list(user, "Какую из частей вы хотите удалить?", "[language_datum]", choices)
				if(isnull(choice))
					return
				var/spoken = FALSE
				var/understood = FALSE
				switch(choice)
					if("Возможность говорить")
						spoken = TRUE
					if("Возможность понимать")
						understood = TRUE
					if("Обе")
						spoken = TRUE
						understood = TRUE
				language_holder.remove_language(language_datum, understood, spoken)
				if(is_admin)
					message_admins("[key_name_admin(user)] удаляет язык [language_name] у [key_name_admin(AM)].")
					log_admin("[key_name(user)] удаляет язык [language_name] у [key_name(AM)].")
				. = TRUE
		if("toggle_omnitongue")
			if(is_admin || isobserver(AM))
				language_holder.omnitongue = !language_holder.omnitongue
				if(is_admin)
					message_admins("[key_name_admin(user)] [language_holder.omnitongue ? "enabled" : "disabled"] the ability to speak all languages (that they know) of [key_name_admin(AM)].")
					log_admin("[key_name(user)] [language_holder.omnitongue ? "enabled" : "disabled"] the ability to speak all languages (that_they know) of [key_name(AM)].")
				. = TRUE
