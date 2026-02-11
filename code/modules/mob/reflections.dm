/proc/get_reflection_alpha(ref_type)
	switch(ref_type)
		if(REFLECTION_MATTE)
			return 70
		if(REFLECTION_REFLECTIVE)
			return 95
		if(REFLECTION_SHINY)
			return 110
		if(REFLECTION_WATER) // Because it gets the water overlay ontop of it
			return 120
		if(REFLECTION_MIRROR)
			return 170
	return 0

#define REFLECTION_MODE_NONE 0
#define REFLECTION_MODE_SURFACE 1
#define REFLECTION_MODE_MIRROR 2

/turf
	var/reflection_type = null

/obj/structure/mirror
	var/reflection_type = REFLECTION_MIRROR

/obj/effect/reflection
	icon = null
	icon_state = null
	appearance_flags = PIXEL_SCALE | KEEP_TOGETHER
	layer = TURF_LAYER + 0.1
	plane = GAME_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/reflection_type = REFLECTION_SHINY

/obj/effect/reflection_proxy
	icon = null
	icon_state = null
	appearance_flags = PIXEL_SCALE | KEEP_TOGETHER
	layer = TURF_LAYER + 0.1
	plane = GAME_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = VIS_INHERIT_DIR

/obj/effect/reflection_capture
	icon = null
	icon_state = null
	appearance_flags = PIXEL_SCALE | KEEP_TOGETHER
	layer = TURF_LAYER + 0.1
	plane = GAME_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = VIS_INHERIT_PLANE | VIS_INHERIT_LAYER | VIS_INHERIT_DIR

/mob/living
	var/obj/effect/reflection/current_reflection
	var/obj/effect/reflection_proxy/reflection_proxy
	var/last_reflection_type = null
	var/last_reflection_mode = REFLECTION_MODE_NONE
	var/obj/structure/mirror/last_reflection_mirror = null
	var/reflections_enabled = FALSE

/mob/living/carbon/human
	reflections_enabled = TRUE

/mob/living/carbon/human/dummy
	reflections_enabled = FALSE

/mob/living/Initialize()
	. = ..()
	if(reflections_enabled)
		setup_reflection()
		check_reflection()

/mob/living/Destroy()
	cleanup_reflection()
	return ..()

/mob/living/proc/cleanup_reflection()
	if(reflection_proxy)
		if(current_reflection)
			current_reflection.vis_contents -= reflection_proxy
		qdel(reflection_proxy)
		reflection_proxy = null

	if(current_reflection)
		qdel(current_reflection)
		current_reflection = null

	last_reflection_type = null
	last_reflection_mode = REFLECTION_MODE_NONE
	last_reflection_mirror = null
	UnregisterSignal(src, list(COMSIG_MOVABLE_MOVED, COMSIG_ATOM_DIR_CHANGE, COMSIG_MOB_OVERLAY_FORCE_UPDATE, COMSIG_MOB_OVERLAY_FORCE_REMOVE))

/mob/living/proc/setup_reflection()
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(check_reflection))
	RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, PROC_REF(check_reflection))
	RegisterSignal(src, COMSIG_MOB_OVERLAY_FORCE_UPDATE, PROC_REF(check_reflection))
	RegisterSignal(src, COMSIG_MOB_OVERLAY_FORCE_REMOVE, PROC_REF(check_reflection))

	current_reflection = new()
	current_reflection.alpha = 0

	reflection_proxy = new()
	current_reflection.vis_contents += reflection_proxy
	sync_reflection_proxy(TRUE)

/mob/living/proc/check_reflection(datum/source, arg2, arg3, arg4)
	SIGNAL_HANDLER
	if(!current_reflection)
		return

	var/reflection_dir = dir
	// COMSIG_ATOM_DIR_CHANGE fires before dir mutates; use provided new_dir immediately.
	if((arg2 in GLOB.cardinals) && (arg3 in GLOB.cardinals))
		reflection_dir = arg3

	var/obj/structure/mirror/M = find_reflection_mirror()
	if(M)
		if(!position_reflection_for_mirror(M, reflection_dir))
			hide_reflection()
			return

		if(last_reflection_type == M.reflection_type && last_reflection_mode == REFLECTION_MODE_MIRROR && last_reflection_mirror == M)
			show_reflection()
			return

		update_reflection(M.reflection_type, REFLECTION_MODE_MIRROR, M)
		return

	var/turf/current_turf = get_turf(src)
	var/turf/T = get_step(src, SOUTH)
	var/new_reflection_type = null
	var/fallback_on_current_turf = FALSE

	if(istype(T))
		new_reflection_type = T.reflection_type

	// Only let water fall back to current turf so shoreline/edge tiles can still reflect
	// without creating persistent floor clones elsewhere.
	if(!new_reflection_type)
		T = current_turf
		if(istype(current_turf))
			new_reflection_type = current_turf.reflection_type
		if(new_reflection_type == REFLECTION_WATER)
			fallback_on_current_turf = TRUE
		else
			new_reflection_type = null

	if(!istype(T) || !new_reflection_type)
		hide_reflection()
		return

	position_reflection_for_surface(T, reflection_dir, fallback_on_current_turf)

	if(new_reflection_type == last_reflection_type && last_reflection_mode == REFLECTION_MODE_SURFACE)
		show_reflection()
		return

	update_reflection(new_reflection_type, REFLECTION_MODE_SURFACE)

/mob/living/proc/find_reflection_mirror()
	var/turf/current_turf = get_turf(src)
	if(!current_turf)
		return null

	for(var/obj/structure/mirror/M in current_turf)
		if(can_use_mirror_reflection(M))
			return M

	for(var/obj/structure/mirror/M in orange(1, src))
		if(can_use_mirror_reflection(M))
			return M

	return null

/mob/living/proc/can_use_mirror_reflection(obj/structure/mirror/M)
	if(!M || QDELETED(M))
		return FALSE
	if(M.obj_broken)
		return FALSE
	return get_dist(src, M) <= 1

/mob/living/proc/sync_reflection_proxy(lock_to_base_offsets = FALSE)
	if(!reflection_proxy)
		return

	reflection_proxy.appearance = copy_appearance_filter_overlays(src.appearance)
	// Re-apply relay behavior after copying appearance so direction updates always propagate.
	reflection_proxy.vis_flags = VIS_INHERIT_DIR
	reflection_proxy.layer = layer
	reflection_proxy.plane = plane
	if(lock_to_base_offsets)
		// Prevent walk/sway pixel animation from making floor reflections "bounce".
		reflection_proxy.pixel_x = base_pixel_x
		reflection_proxy.pixel_y = base_pixel_y
	else
		reflection_proxy.pixel_x = pixel_x
		reflection_proxy.pixel_y = pixel_y

/mob/living/proc/position_reflection_for_surface(turf/T, reflection_dir = dir, using_current_turf = FALSE)
	if(!current_reflection)
		return

	sync_reflection_proxy(TRUE)
	current_reflection.forceMove(T)
	current_reflection.transform = matrix().Scale(1, -REFLECTION_SQUISH_RATIO)
	current_reflection.pixel_x = 0
	// Keep the reflection visually below the mob, not overlapping into the source tile.
	var/pixel_y_offset = -round(bound_height * (1 - REFLECTION_SQUISH_RATIO) * 0.5)
	if(using_current_turf)
		pixel_y_offset -= world.icon_size
	current_reflection.pixel_y = pixel_y_offset
	current_reflection.layer = TURF_LAYER + 0.1
	current_reflection.plane = GAME_PLANE
	// Floor/water reflections should keep the same facing and only be vertically flipped.
	current_reflection.setDir(reflection_dir)

/mob/living/proc/position_reflection_for_mirror(obj/structure/mirror/M, reflection_dir = dir)
	if(!current_reflection || !M)
		return FALSE

	var/turf/mirror_turf = get_turf(M)
	if(!mirror_turf)
		return FALSE

	sync_reflection_proxy(FALSE)
	current_reflection.forceMove(mirror_turf)
	// Keep reflection inside the mirror glass area.
	current_reflection.transform = matrix().Scale(-0.45, 0.58)
	current_reflection.pixel_x = M.pixel_x
	current_reflection.pixel_y = M.pixel_y + 1
	// Draw in front; alpha mask limits reflection to mirror silhouette.
	current_reflection.layer = M.layer + 0.01
	current_reflection.plane = M.plane
	// Mirror should show front when facing it and back when facing away.
	current_reflection.setDir(REVERSE_DIR(reflection_dir))
	return TRUE

/mob/living/proc/update_reflection(reflection_type, reflection_mode, obj/structure/mirror/mirror_reflection = null)
	if(!current_reflection)
		return

	last_reflection_type = reflection_type
	last_reflection_mode = reflection_mode
	last_reflection_mirror = mirror_reflection
	current_reflection.reflection_type = reflection_type
	current_reflection.filters = null
	current_reflection.color = null

	apply_reflection_effects(current_reflection)
	show_reflection()

/mob/living/proc/show_reflection()
	if(!current_reflection)
		return

	var/target_alpha = get_reflection_alpha(last_reflection_type)

	if(current_reflection.alpha != target_alpha)
		current_reflection.alpha = target_alpha

/mob/living/proc/hide_reflection()
	if(!current_reflection)
		return

	current_reflection.alpha = 0
	current_reflection.filters = null
	current_reflection.color = null
	last_reflection_type = null
	last_reflection_mode = REFLECTION_MODE_NONE
	last_reflection_mirror = null

/mob/living/proc/apply_reflection_effects(obj/effect/reflection/R)
	switch(R.reflection_type)
		if(REFLECTION_MATTE)
			R.filters += filter(type="blur", size=1)
			R.color = list(
				0.5, 0, 0,
				0, 0.5, 0,
				0, 0, 0.5,
				0, 0, 0
			)

		if(REFLECTION_REFLECTIVE)
			R.filters += filter(type="blur", size=0.5)
			R.color = list(
				0.8, 0, 0,
				0, 0.8, 0,
				0, 0, 0.85,
				0, 0, 0
			)

		if(REFLECTION_SHINY)
			R.filters += filter(type="blur", size=0.35)
			R.color = list(
				0.9, 0, 0,
				0, 0.9, 0,
				0, 0, 0.95,
				0, 0, 0
			)

		if(REFLECTION_WATER)
			R.color = list(
				0.7, 0, 0,
				0, 0.7, 0,
				0, 0, 0.9,
				0, 0, 0
			)

			R.filters += filter(type="wave", x=2, y=2, size=1, offset=0)
			animate(R.filters[R.filters.len], offset=1000000, time=10000000, easing=LINEAR_EASING)

		if(REFLECTION_MIRROR)
			R.filters += filter(type="blur", size=0.25)
			if(last_reflection_mirror?.reflection_mask_target)
				R.filters += filter(type="alpha", render_source = last_reflection_mirror.reflection_mask_target)
			R.color = list(
				0.95, 0, 0,
				0, 0.95, 0,
				0, 0, 1,
				0, 0, 0
			)

#undef REFLECTION_MODE_NONE
#undef REFLECTION_MODE_SURFACE
#undef REFLECTION_MODE_MIRROR
