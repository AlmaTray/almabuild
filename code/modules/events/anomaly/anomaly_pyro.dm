/datum/round_event_control/anomaly/anomaly_pyro
	name = "Anomaly: Pyroclastic"
	typepath = /datum/round_event/anomaly/anomaly_pyro

	max_occurrences = 5
	weight = 20
	description = "This anomaly sets things on fire, and creates a pyroclastic slime."
	min_wizard_trigger_potency = 1
	max_wizard_trigger_potency = 4

/datum/round_event/anomaly/anomaly_pyro
	start_when = 3
	announce_when = 10
	anomaly_path = /obj/effect/anomaly/pyro

/datum/round_event/anomaly/anomaly_pyro/announce(fake)
	priority_announce("Pyroclastic anomaly detected on long range scanners. Expected location: [impact_area.name].", "Anomaly Alert", ANNOUNCER_PYROANOMALIES) //SKYRAT EDIT CHANGE
