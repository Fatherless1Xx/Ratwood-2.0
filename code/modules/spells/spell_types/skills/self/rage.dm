/obj/effect/proc_holder/spell/self/barbarian_rage
	name = "Rage"
	desc = "Enter a state of martial fervor, increasing offensive capabilities at the cost of making yourself vulnerable."
	overlay_state = "call_to_arms"
	recharge_time = 5 MINUTES
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	movement_interrupt = FALSE
	sound = 'sound/magic/barbroar.ogg'
	associated_skill = /datum/skill/combat/unarmed
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/self/barbarian_rage/cast(mob/living/user)
	if(!isliving(user))
		return FALSE
	user.emote("rage", forced = TRUE)
	user.apply_status_effect(/datum/status_effect/buff/barbarian_rage)
	return TRUE
