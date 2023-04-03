/datum/action/language_menu
	name = "Меню языков"
	desc = "Используйте меню языков, чтобы узнать ваши языки, их назначения, а также ваш основной язык."
	button_icon_state = "language_menu"
	check_flags = NONE

/datum/action/language_menu/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return

	var/datum/language_holder/owner_holder = owner.get_language_holder()
	owner_holder.open_language_menu(usr)
