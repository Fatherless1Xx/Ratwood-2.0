/mob/proc/add_stress(event_type)
	return

/mob/proc/remove_stress(event_type)
	return

/mob/proc/add_stress_list(list/event_list)
	return

/mob/proc/remove_stress_list(list/event_list)
	return

/mob/proc/update_stress()
	return

/mob/proc/get_stress_amount()
	return 0

/mob/proc/get_stress_event(event_type)
	return null

/mob/proc/has_stress_event(event_type)
	return FALSE

/mob/proc/get_positive_stressors()
	return list()

/mob/proc/get_negative_stressors()
	return list()

/mob/living/carbon
	var/oldstress = 0
	var/list/stressors = list()
	var/atom/movable/screen/text/stress_popup
	var/atom/movable/screen/text/stress_message_blurb

/mob/living/carbon/proc/get_stress_popup_screen_position(horizontal_side = null, vertical_side = null)
	// Explicit 50/50 side and vertical picks to remove placement bias.
	if(!horizontal_side)
		horizontal_side = pick("left", "right")
	if(!vertical_side)
		vertical_side = pick("bottom", "top")
	var/x = (horizontal_side == "left") ? rand(2, 4) : rand(9, 11)
	var/y = (vertical_side == "bottom") ? rand(2, 4) : rand(10, 12)
	var/pixel_x = rand(0, 18)
	var/pixel_y = rand(0, 18)
	return "WEST+[x]:[pixel_x],SOUTH+[y]:[pixel_y]"

/mob/living/carbon/proc/show_stress_popup(message, text_color = "#FFFFFF", duration = 3 SECONDS, fade_time = 0.5 SECONDS, speed = 0.5, screen_position = null, text_alignment = "left")
	if(!client || !message)
		return
	if(stress_popup)
		client.screen -= stress_popup
		qdel(stress_popup)
		stress_popup = null
	if(!screen_position)
		screen_position = get_stress_popup_screen_position()
	var/style = "font-family: 'Fixedsys'; font-size: 6px; text-align: [text_alignment]; color: [text_color]; -dm-text-outline: 1px #000000;"
	var/atom/movable/screen/text/popup = ScreenText(null, "", screen_position, 96, 260)
	stress_popup = popup
	client.screen += popup
	INVOKE_ASYNC(src, PROC_REF(type_stress_popup), popup, message, style, speed)
	addtimer(CALLBACK(src, PROC_REF(clear_stress_popup), popup, fade_time), duration)

/mob/living/carbon/proc/type_stress_popup(atom/movable/screen/text/popup, message, style, speed = 0.5)
	if(!popup)
		return
	for(var/i in 1 to length(message) + 1)
		if(QDELETED(popup) || popup != stress_popup)
			return
		popup.maptext = MAPTEXT("<span style=\"[style]\">[html_encode(copytext(message, 1, i))]</span>")
		if(speed)
			sleep(speed)

/mob/living/carbon/proc/clear_stress_popup(atom/movable/screen/text/popup, fade_time = 0.5 SECONDS)
	if(!popup)
		return
	animate(popup, alpha = 0, time = fade_time, easing = EASE_OUT)
	addtimer(CALLBACK(src, PROC_REF(remove_stress_popup), popup), fade_time + 1)

/mob/living/carbon/proc/remove_stress_popup(atom/movable/screen/text/popup)
	if(!popup)
		return
	if(client)
		client.screen -= popup
	if(stress_popup == popup)
		stress_popup = null
	qdel(popup)

/mob/living/carbon/proc/get_stress_blurb_screen_position(horizontal_side = "left", vertical_side = "bottom")
	var/x = (horizontal_side == "left") ? rand(1, 3) : rand(9, 11)
	var/y = (vertical_side == "bottom") ? rand(2, 6) : rand(9, 13)
	var/pixel_x = rand(0, 20)
	var/pixel_y = rand(0, 20)
	return "WEST+[x]:[pixel_x],SOUTH+[y]:[pixel_y]"

/mob/living/carbon/proc/show_stress_blurb(message, duration = 3 SECONDS, fade_time = 3 SECONDS, screen_position = "WEST+2,SOUTH+2", text_alignment = "left")
	if(!client || !message)
		return
	if(stress_message_blurb)
		client.screen -= stress_message_blurb
		qdel(stress_message_blurb)
		stress_message_blurb = null
	var/style = "font-family: 'Fixedsys'; font-size: 6px; text-align: [text_alignment]; color: #ff0000; -dm-text-outline: 1px #000000;"
	var/atom/movable/screen/text/blurb = ScreenText(null, MAPTEXT("<span style=\"[style]\">[html_encode(message)]</span>"), screen_position, 96, 205)
	switch(text_alignment)
		if("center")
			blurb.maptext_x = -86
		if("right")
			blurb.maptext_x = -173
		else
			blurb.maptext_x = -12
	stress_message_blurb = blurb
	client.screen += blurb
	addtimer(CALLBACK(src, PROC_REF(clear_stress_blurb), blurb, fade_time), duration)

/mob/living/carbon/proc/clear_stress_blurb(atom/movable/screen/text/blurb, fade_time = 3 SECONDS)
	if(!blurb)
		return
	animate(blurb, alpha = 0, time = fade_time, easing = EASE_OUT)
	addtimer(CALLBACK(src, PROC_REF(remove_stress_blurb), blurb), fade_time + 1)

/mob/living/carbon/proc/remove_stress_blurb(atom/movable/screen/text/blurb)
	if(!blurb)
		return
	if(client)
		client.screen -= blurb
	if(stress_message_blurb == blurb)
		stress_message_blurb = null
	qdel(blurb)

/mob/living/carbon/add_stress(event_type)
	var/datum/stressevent/event = get_stress_event(event_type)
	if(!event)
		event = new event_type()
		if(!event.can_apply(src))
			return
		stressors[event_type] = event
	event.time_added = world.time
	if(event.stacks >= event.max_stacks)
		return event
	event.stacks++
	return event

/mob/living/carbon/remove_stress(event_type)
	var/datum/stressevent/event = get_stress_event(event_type)
	if(!event)
		return
	stressors -= event_type

/mob/living/carbon/add_stress_list(list/event_list)
	for(var/event_type in event_list)
		add_stress(event_type)

/mob/living/carbon/remove_stress_list(list/event_list)
	for(var/event_type in event_list)
		remove_stress(event_type)

/mob/living/carbon/update_stress()
	// Handle expiration and accumulate our new stress status in the same operation
	if (!client) // no reason to fire stress at all on npcs
		return
	if (stat != CONSCIOUS) // oblivion preserves our stress, for better or worse. (read: life optimizations weewoo)
		return
	var/new_stress = get_stress_amount()
	for(var/stressor_type in stressors)
		var/datum/stressevent/event = stressors[stressor_type]
		if(event.time_added + event.timer > world.time)
			continue
		remove_stress(stressor_type)

	// move bleeding stress handling here
	if (bleed_rate)
		add_stress(/datum/stressevent/bleeding)
	else
		remove_stress(/datum/stressevent/bleeding)

	var/ascending = (new_stress > oldstress)

	if(new_stress != oldstress)
		var/diff_abs = abs(new_stress - oldstress)
		if(diff_abs > 1)
			if(ascending)
				show_stress_popup("I gain stress.", "#dc7373")
				if(diff_abs > 2)
					if(!rogue_sneaking || alpha >= 100)
						play_stress_indicator()
			else
				show_stress_popup("I gain peace.", "#6fd58a")
				if(diff_abs > 2)
					if(!rogue_sneaking || alpha >= 100)
						play_relief_indicator()

	var/old_threshold = get_stress_threshold(oldstress)
	var/new_threshold = get_stress_threshold(new_stress)
	if(old_threshold != new_threshold)
		remove_status_effect(/datum/status_effect/mood)
		switch(new_threshold)
			if(STRESS_THRESHOLD_NICE)
				show_stress_popup("I feel great!", "#69d58c")
				apply_status_effect(/datum/status_effect/mood/vgood)
			if(STRESS_THRESHOLD_GOOD)
				if(ascending)
					show_stress_popup("I no longer feel as good.", "#d3d8df")
				else
					show_stress_popup("I feel good.", "#7ce09b")
				apply_status_effect(/datum/status_effect/mood/good)
			if(STRESS_THRESHOLD_NEUTRAL)
				if(ascending)
					show_stress_popup("I no longer feel good.", "#d3d8df")
				else
					show_stress_popup("I no longer feel stressed.", "#d3d8df")
			if(STRESS_THRESHOLD_STRESSED)
				if(ascending)
					show_stress_popup("I'm getting stressed...", "#ff8a8a")
				else
					show_stress_popup("I'm stressed a little less, now.", "#ff8a8a")
				apply_status_effect(/datum/status_effect/mood/bad)
			if(STRESS_THRESHOLD_STRESSED_BAD)
				if(!HAS_TRAIT(src, TRAIT_EORAN_CALM) && !HAS_TRAIT(src, TRAIT_EORAN_SERENE))
					if(ascending)
						show_stress_popup("I'm getting at my limit...", "#ff5f5f")
					else
						show_stress_popup("I'm not freaking out that badly anymore.", "#ff5f5f")
					apply_status_effect(/datum/status_effect/mood/vbad)
			if(STRESS_THRESHOLD_FREAKING_OUT)
				show_stress_popup("I'M FREAKING OUT!!!", "#ff3e3e")
				play_mental_break_indicator()
				apply_status_effect(/datum/status_effect/mood/vbad)

	if(new_threshold >= STRESS_THRESHOLD_STRESSED)
		if(old_threshold < STRESS_THRESHOLD_STRESSED)
			mob_timers["next_stress_message"] = 0
		random_stress_message()
	else
		mob_timers["next_stress_message"] = 0

	if(new_stress >= 20)
		if(!HAS_TRAIT(src, TRAIT_EORAN_CALM) && !HAS_TRAIT(src, TRAIT_EORAN_SERENE))
			roll_streak_freakout()

	oldstress = new_stress
	update_stress_visual(new_stress)

/mob/living/carbon/proc/update_stress_visual(new_stress)
	if(!client)
		return
	/// Update grain alpha
	//var/atom/movable/screen/grain_obj = hud_used.grain
	//grain_obj.alpha = 55 + (new_stress * 1.5)

	var/fade_progress = 0
	if(new_stress < 5)
		fade_progress = 0
		remove_client_colour(/datum/client_colour/stress_fade)
	else
		fade_progress = clamp(((new_stress - 5) / 50), 0, 0.6)

	/// Update screen black/white
	var/datum/client_colour/stress_fade/fade_color = add_client_colour(/datum/client_colour/stress_fade)
	var/list/matrix = fade_color.colour
	//RED FADE
	// R fade is 0.3
	var/r_fade = 0.3 * fade_progress
	var/red = 1.0 - (0.7 * fade_progress)
	matrix[1] = red // RED
	matrix[2] = r_fade
	matrix[3] = r_fade
	//GREEN FADE
	// G fade is 0.6
	var/g_fade = 0.6 * fade_progress
	var/green = 1.0 - (0.4 * fade_progress)
	matrix[5] = g_fade
	matrix[6] = green // GREEN
	matrix[7] = g_fade
	//BLUE FADE
	// B fade is 0.1
	var/b_fade = 0.1 * fade_progress
	var/blue = 1.0 - (0.9 * fade_progress)
	matrix[9] = b_fade
	matrix[10] = b_fade
	matrix[11] = blue // BLUE

	update_client_colour()

/mob/living/carbon/proc/roll_streak_freakout()
	if(stat != CONSCIOUS)
		return
	if(mob_timers["next_stress_freakout"])
		if(world.time < mob_timers["next_stress_freakout"])
			return
	if(!prob(20)) // 20% per update to make it less consistent
		return
	// Randomized cooldown
	mob_timers["next_stress_freakout"] = world.time + rand(60 SECONDS, 120 SECONDS)
	stress_freakout()

/mob/living/carbon/proc/stress_freakout()
	show_stress_popup("I PANIC!!!", "#ff3e3e")
	Stun(2 SECONDS)
	blur_eyes(2)
	freakout_hud_skew()
	add_stress(/datum/stressevent/freakout)
	emote("fatigue", forced = TRUE)
	addtimer(CALLBACK(src, PROC_REF(do_stress_freakout_scream)), rand(1 SECONDS, 2 SECONDS))

/mob/living/carbon/proc/do_stress_freakout_scream()
	if(stat != CONSCIOUS)
		return
	emote("scream", forced = TRUE)

/mob/living/carbon/proc/freakout_hud_skew()
	if(!hud_used)
		return
	var/matrix/skew = matrix()
	skew.Scale(1.5)
	var/matrix/newmatrix = skew
	for(var/C in hud_used.plane_masters)
		var/atom/movable/screen/plane_master/whole_screen = hud_used.plane_masters[C]
		if(whole_screen.plane == HUD_PLANE)
			continue
		animate(whole_screen, transform = newmatrix, time = 1, easing = QUAD_EASING)
		animate(transform = -newmatrix, time = 30, easing = QUAD_EASING)

/mob/living/carbon/proc/random_stress_message()
	if(mob_timers["next_stress_message"])
		if(world.time < mob_timers["next_stress_message"])
			return
	mob_timers["next_stress_message"] = world.time + rand(8 SECONDS, 14 SECONDS)
	var/stress_message_picked = pick_list("rt/stress_messages.json", "insanity")
	var/horizontal_side = pick("left", "right")
	var/vertical_side = pick("bottom", "top")
	var/text_alignment = (horizontal_side == "left") ? "left" : "right"
	show_stress_blurb(
		stress_message_picked,
		screen_position = get_stress_blurb_screen_position(horizontal_side, vertical_side),
		text_alignment = text_alignment
	)


/mob/living/carbon/get_stress_amount()
	var/willpowerresistance = CLAMP((STAWIL - 10), 0, 10)
	var/wpmodifier = willpowerresistance / 3
	if(HAS_TRAIT(src, TRAIT_NOMOOD))
		return 0
	var/total_stress = 0
	for(var/stressor_type in stressors)
		var/datum/stressevent/event = stressors[stressor_type]
		var/stress_amt = event.get_stress(src)
		if(stress_amt > 0 && HAS_TRAIT(src, TRAIT_BAD_MOOD))
			stress_amt *= 2
		if(stress_amt > 0 && HAS_TRAIT(src, TRAIT_EORAN_SERENE))
			stress_amt = (stress_amt * -1)	//We make the bad things feel good.
		if((stress_amt >= 0) && (wpmodifier > 0))
			stress_amt = CLAMP((stress_amt -= wpmodifier), 0, INFINITY)
		total_stress += stress_amt
	return total_stress

/mob/living/carbon/get_stress_event(event_type)
	return stressors[event_type]

/mob/living/carbon/has_stress_event(event_type)
	if(stressors[event_type])
		return TRUE
	return FALSE

/mob/living/carbon/get_positive_stressors()
	. = list()
	for(var/stressor_type in stressors)
		var/datum/stressevent/event = stressors[stressor_type]
		if(event.get_stress(src) <= 0)
			. += event

/mob/living/carbon/get_negative_stressors()
	. = list()
	for(var/stressor_type in stressors)
		var/datum/stressevent/event = stressors[stressor_type]
		if(event.get_stress(src) > 0)
			. += event

/proc/get_stress_threshold(stress_amt)
	switch(stress_amt)
		if(-INFINITY to -4)
			return STRESS_THRESHOLD_NICE
		if(-4 to 0)
			return STRESS_THRESHOLD_GOOD
		if(0 to 4)
			return STRESS_THRESHOLD_NEUTRAL
		if(4 to 11)
			return STRESS_THRESHOLD_STRESSED
		if(11 to 19)
			return STRESS_THRESHOLD_STRESSED_BAD
		if(19 to INFINITY)
			return STRESS_THRESHOLD_FREAKING_OUT

/mob/living/carbon/add_stress_list(list/event_list)
	for(var/event_type in event_list)
		add_stress(event_type)

/mob/living/carbon/remove_stress_list(list/event_list)
	for(var/event_type in event_list)
		remove_stress(event_type)
