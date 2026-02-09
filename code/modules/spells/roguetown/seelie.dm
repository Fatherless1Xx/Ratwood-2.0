/obj/effect/proc_holder/spell/invoked/seelie_dust
	name = "Seelie Dust"
	overlay_state = "createlight"
	releasedrain = 50
	recharge_time = 150 SECONDS
	range = 7
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	invocation_type = "none"

/obj/effect/proc_holder/spell/invoked/seelie_dust/cast(list/targets, mob/living/user)
	. = ..()
	user.emote("giggle")
	var/mob/living/target = targets[1]
	if(isliving(target))
		target.apply_status_effect(/datum/status_effect/buff/seelie_drugs)
		target.adjustToxLoss(15)
		target.visible_message(span_danger("[user] dusts [target] with some kind of powder!"))
		user.log_message("has drugged [key_name(target)] with Seelie dust", LOG_ATTACK)
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/invoked/summon_rat
	name = "Call Beast"
	overlay_state = "dendor"
	releasedrain = 30
	recharge_time = 90 SECONDS
	range = 7
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	invocation_type = "none"

/obj/effect/proc_holder/spell/invoked/summon_rat/cast(list/targets, mob/user)
	. = ..()
	var/turf/T = get_turf(targets[1])
	user.emote("giggle")
	if(prob(1))
		new /mob/living/simple_animal/hostile/retaliate/rogue/bigrat(T)
		user.log_message("has summoned a rous in an attempt to summon rat", LOG_GAME)
	else
		new /obj/item/reagent_containers/food/snacks/smallrat(T)
		user.log_message("has summoned a rat through the spell", LOG_GAME)
	return TRUE

/obj/effect/proc_holder/spell/targeted/roustame
	name = "Tame Rous"
	range = 5
	overlay_state = "tamebeast"
	releasedrain = 30
	recharge_time = 1 MINUTES
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	invocations = list("Feel my presence, and be calmed.")
	invocation_type = "whisper"

/obj/effect/proc_holder/spell/targeted/roustame/cast(list/targets, mob/user = usr)
	. = ..()
	visible_message(span_green("[usr] soothes the beast with Seelie dust."))
	if(!targets.len || !istype(targets[1], /mob/living/simple_animal/hostile/retaliate/rogue/bigrat))
		to_chat(user, span_warning("You must target a valid rous!"))
		return FALSE
	for(var/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/B in oview(2, user))
		if(!B.tame)
			B.tamed(user)
			B.faction += list("neutral")
		B.enemies = list()
		B.aggressive = FALSE
		B.LoseTarget()
	user.log_message("has tamed a rous via the spell", LOG_GAME)
	return TRUE

/obj/effect/proc_holder/spell/targeted/seelie_kiss
	name = "Regenerative Kiss"
	overlay_state = "heal"
	releasedrain = 0
	recharge_time = 90 SECONDS
	range = 1
	invocation_type = "none"

/obj/effect/proc_holder/spell/targeted/seelie_kiss/cast(list/targets, mob/user)
	. = ..()
	if(!iscarbon(targets[1]))
		return FALSE
	var/mob/living/carbon/target = targets[1]
	target.adjustBruteLoss(-10)
	target.adjustFireLoss(-10)
	target.add_nausea(9)
	target.updatehealth()
	to_chat(target, span_notice("I suddenly feel reinvigorated!"))
	to_chat(user, span_notice("I have reinvigorated [target] with a kiss."))
	user.log_message("has blessed [key_name(target)] with a kiss spell, healing them a little", LOG_ATTACK)
	target.log_message("has been blessed by [key_name(user)] with a kiss spell, healing them a little", LOG_ATTACK)
	user.emote("kiss")
	return TRUE
