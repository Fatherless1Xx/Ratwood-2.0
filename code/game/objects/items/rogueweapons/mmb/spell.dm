/datum/intent/spell
	name = "spell"
	tranged = 1
	chargedrain = 0
	chargetime = 0
	warnie = "aimwarn"
	warnoffset = 0
	var/obj/effect/spell_cast_rune/charge_rune = null

/datum/intent/spell/can_charge(atom/clicked_object)
	var/obj/effect/proc_holder/spell/spell_ability = mastermob.ranged_ability
	if(istype(spell_ability) && !spell_ability.charge_check(mastermob, TRUE))
		to_chat(mastermob, span_warning("This spell needs time to recharge!"))
		return FALSE
	return TRUE

/datum/intent/spell/on_mmb(atom/target, mob/living/user, params)
	if(!target)
		return
	if(istype(target, /atom/movable/screen/click_catcher))
		return
	var/obj/effect/proc_holder/spell/spell_ability = user?.ranged_ability
	if(istype(spell_ability) && spell_ability.require_mmb_target_after_charge && spell_ability.awaiting_mmb_target)
		if(!isliving(target))
			return
		if(!spell_ability.can_target(target))
			return
	if(user.ranged_ability?.InterceptClickOn(user, params, target))
		user.changeNext_move(clickcd)
		if(releasedrain)
			user.stamina_add(releasedrain)

/datum/intent/spell/on_charge_complete()
	var/obj/effect/proc_holder/spell/spell_ability = mastermob?.ranged_ability
	if(!istype(spell_ability))
		return
	if(spell_ability.require_mmb_target_after_charge)
		spell_ability.awaiting_mmb_target = TRUE
		if(mastermob?.client)
			if(charged_pointer)
				mastermob.client.mouse_pointer_icon = charged_pointer
			else
				mastermob.client.mouse_pointer_icon = 'icons/effects/mousemice/charge/default/100.dmi'
		to_chat(mastermob, span_notice("[spell_ability.name] is fully charged. Middle-click a target to cast."))

/datum/intent/spell/on_charge_start()
	..()
	if(!mastermob)
		return
	if(!charge_rune)
		charge_rune = new
	mastermob.vis_contents += charge_rune
	spawn_charge_particles()
	var/obj/effect/temp_visual/spell_charge_wave_up/wave = new
	mastermob.vis_contents += wave

/datum/intent/spell/proc/spawn_charge_particles()
	if(!mastermob || mastermob.curplaying != src)
		return
	var/obj/effect/temp_visual/spell_charge_particle_up/particles = new
	mastermob.vis_contents += particles
	addtimer(CALLBACK(src, PROC_REF(spawn_charge_particles)), 3.6 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

/datum/intent/spell/on_mouse_up()
	var/obj/effect/proc_holder/spell/spell_ability = mastermob?.ranged_ability
	var/keep_rune = istype(spell_ability) && spell_ability.require_mmb_target_after_charge
	if(keep_rune && mastermob?.client?.chargedprog >= 100)
		spell_ability.awaiting_mmb_target = TRUE
	else if(istype(spell_ability))
		spell_ability.awaiting_mmb_target = FALSE
	if(mob_charge_effect && mastermob)
		mastermob.vis_contents -= mob_charge_effect
	if(keep_rune && spell_ability.awaiting_mmb_target && mob_charge_effect && mastermob)
		mastermob.vis_contents |= mob_charge_effect
		keep_rune = TRUE
	else
		keep_rune = FALSE
	if(!keep_rune)
		..()
	else
		if(chargedloop)
			chargedloop.stop()
		if(mastermob?.curplaying == src)
			mastermob?.curplaying = null
		if(mob_light)
			qdel(mob_light)
	if(!keep_rune)
		if(charge_rune && mastermob)
			mastermob.vis_contents -= charge_rune
		QDEL_NULL(charge_rune)
