/obj/effect/spell_rune
	name = "spell rune"
	desc = "A rune indicating a caster is channeling magic."
	icon = 'icons/mob/actions/roguespells.dmi'
	icon_state = "spell0"
	vis_flags = NONE
	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE_UPPER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	base_pixel_x = 0
	base_pixel_y = 28
	pixel_x = 0
	pixel_y = 28
	var/base_color = null
	var/icon/overlay_icon
	var/overlay_state
	var/overlay_alpha = 255

/obj/effect/spell_rune/Initialize()
	. = ..()
	base_color = color

/obj/effect/spell_rune/proc/set_overlay(icon/overlay_file, overlay_state_name, alpha_override = 255)
	overlay_icon = overlay_file
	overlay_state = overlay_state_name
	overlay_alpha = alpha_override
	overlays.Cut()
	if(overlay_icon && overlay_state && overlay_state != "null")
		icon = overlay_icon
		icon_state = overlay_state
		alpha = overlay_alpha
	else
		icon = initial(icon)
		icon_state = initial(icon_state)
		alpha = initial(alpha)

/obj/effect/spell_rune/proc/use_miracle_icon()
	icon = 'icons/effects/miracle-healing.dmi'
	icon_state = ""

/obj/effect/spell_rune/proc/set_tint(tint_color)
	if(isnull(base_color))
		base_color = color
	color = tint_color

/obj/effect/spell_rune/proc/clear_tint()
	color = base_color

/obj/effect/spell_charge_particles
	name = "spell particles"
	icon = 'icons/effects/spell_cast.dmi'
	icon_state = "particle_up"
	vis_flags = NONE
	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE_UPPER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	base_pixel_x = 0
	base_pixel_y = -8
	pixel_x = 0
	pixel_y = -8

/obj/effect/temp_visual/spell_charge_particle_up
	name = "spell particles"
	icon = 'icons/effects/spell_cast.dmi'
	icon_state = "particle_up"
	vis_flags = NONE
	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE_UPPER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	base_pixel_x = 0
	base_pixel_y = -8
	pixel_x = 0
	pixel_y = -8
	duration = 3.8 SECONDS

/obj/effect/spell_cast_rune
	name = "spell cast rune"
	icon = 'icons/effects/spell_cast.dmi'
	icon_state = "rune"
	vis_flags = NONE
	layer = BELOW_MOB_LAYER
	plane = GAME_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	base_pixel_x = -8
	base_pixel_y = -8
	pixel_x = -8
	pixel_y = -8

/obj/effect/temp_visual/spell_charge_wave_up
	name = "spell wave"
	icon = 'icons/effects/spell_cast.dmi'
	icon_state = "wave_up"
	vis_flags = NONE
	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE_UPPER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	base_pixel_x = -8
	base_pixel_y = -8
	pixel_x = -8
	pixel_y = -8
	duration = 1.8 SECONDS
