/datum/quirk/equipping/nerve_staple
	name = "Nerve Stapled"
	desc = "Вы пацифист, не по своим убеждениям, а из-за устройства установленного на вас."
	value = -10 // pacifism = -8, losing eye slots = -2
	gain_text = span_danger("Внезапно вы понимаете, что не можете навредить кому либо.")
	lose_text = span_notice("Ты думаешь, что сможешь снова защитить себя.")
	medical_record_text = "В связи с устройством на пациенте, он не может кому либо навредить. "
	icon = "hand-peace"
	forced_items = list(/obj/item/clothing/glasses/nerve_staple = list(ITEM_SLOT_EYES))
	/// The nerve staple attached to the quirk
	var/obj/item/clothing/glasses/nerve_staple/staple

/datum/quirk/equipping/nerve_staple/on_equip_item(obj/item/equipped, successful)
	if (!istype(equipped, /obj/item/clothing/glasses/nerve_staple))
		return
	staple = equipped

/datum/quirk/equipping/nerve_staple/remove()
	. = ..()
	if (!staple || staple != quirk_holder.get_item_by_slot(ITEM_SLOT_EYES))
		return
	to_chat(quirk_holder, span_warning("Устройство внезапно падает с вашего лица и плавится.[istype(quirk_holder.loc, /turf/open/floor) ? " on the floor" : ""]!"))
	qdel(staple)

// Re-labels TG brainproblems to be more generic. There never was a tumor anyways!
/datum/quirk/item_quirk/brainproblems
	name = "Brain Degeneration"
	desc = "У вас смертельное заболевание в вашем мозгу, которое медленно разрушает его. Запасайтесь маннитолом!"
	medical_record_text = "У пациента смертельное заболевание головного мозга, которое медленно вызывает смерть мозга."

// Override of Brain Tumor quirk for robotic/synthetic species with posibrains.
// Does not appear in TGUI or the character preferences window.
/datum/quirk/item_quirk/brainproblems/synth
	name = "Positronic Cascade Anomaly"
	desc = "Ваш позитронный мозг медленно разрушается из-за каскадной аномалии. Лучше принеси немного жидкого припоя!"
	gain_text = "<span class='danger'>Вы чувствуете себя сбойным.</span>"
	lose_text = "<span class='notice'>Вы больше не чувствуете себя сбойным.</span>"
	medical_record_text = "У пациента каскадная аномалия в головном мозге, которая медленно вызывает смерть мозга."
	icon = "bp_synth_brain"
	mail_goodies = list(/obj/item/storage/pill_bottle/liquid_solder/braintumor)
	hidden_quirk = TRUE

// If brainproblems is added to a synth, this detours to the brainproblems/synth quirk.
// TODO: Add more brain-specific detours when PR #16105 is merged
/datum/quirk/item_quirk/brainproblems/add_to_holder(mob/living/new_holder, quirk_transfer, client/client_source)
	if(!issynthetic(new_holder) || type != /datum/quirk/item_quirk/brainproblems)
		// Defer to TG brainproblems if the character isn't robotic.
		return ..()

	// TODO: Check brain type and detour to appropriate brainproblems quirk
	var/datum/quirk/item_quirk/brainproblems/synth/bp_synth = new
	qdel(src)
	return bp_synth.add_to_holder(new_holder, quirk_transfer, client_source)

// Synthetics get liquid_solder with Brain Tumor instead of mannitol.
/datum/quirk/item_quirk/brainproblems/synth/add_unique(client/client_source)
	give_item_to_holder(
		/obj/item/storage/pill_bottle/liquid_solder/braintumor,
		list(
			LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
			LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
			LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
			LOCATION_HANDS = ITEM_SLOT_HANDS,
		),
		flavour_text = "These will keep you alive until you can secure a supply of medication. Don't rely on them too much!",
	)

// Override of Blood Deficiency quirk for robotic/synthetic species.
// Does not appear in TGUI or the character preferences window.
/datum/quirk/blooddeficiency/synth
	name = "Hydraulic Leak"
	desc = "Гидравлические жидкости вашего тела просачиваются через уплотнения."
	medical_record_text = "Пациенту требуется регулярное обслуживание в связи с потерей гидравлической жидкости."
	icon = "bd_synth_tint"
	mail_goodies = list(/obj/item/reagent_containers/blood/oil)
	// min_blood = BLOOD_VOLUME_BAD - 25; // TODO: Uncomment after TG PR #70563
	hidden_quirk = TRUE

// If blooddeficiency is added to a synth, this detours to the blooddeficiency/synth quirk.
/datum/quirk/blooddeficiency/add_to_holder(mob/living/new_holder, quirk_transfer, client/client_source)
	if(!issynthetic(new_holder) || type != /datum/quirk/blooddeficiency)
		// Defer to TG blooddeficiency if the character isn't robotic.
		return ..()

	var/datum/quirk/blooddeficiency/synth/bd_synth = new
	qdel(src)
	return bd_synth.add_to_holder(new_holder, quirk_transfer)
