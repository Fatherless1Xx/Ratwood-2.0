/datum/sprite_accessory/brand
	abstract_type = /datum/sprite_accessory/brand
	icon = 'icons/mob/body_markings/other_markings.dmi'
	color_key_name = "Brand"
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/brand/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BACK)

/datum/sprite_accessory/brand/vampire_seal
	name = "Vampiric Seal"
	icon_state = "slave_seal"
	//glows = TRUE
	default_colors = COLOR_RED

/datum/sprite_accessory/brand/indentured_womb
	name = "Baothan Womb Mark"
	icon = 'icons/roguetown/misc/baotha_marking.dmi'
	icon_state = "marking"
	layer = BODY_LAYER
	relevant_layers = null

/datum/sprite_accessory/brand/indentured_womb/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner?.gender == FEMALE)
		return "marking_f"
	return "marking_m"

/datum/sprite_accessory/brand/indentured_womb/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/overlay_layer = BODY_LAYER
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		var/crotch_exposed = FALSE
		if(H.sexcon?.bottom_exposed == TRUE)
			crotch_exposed = TRUE
		else if(!H.underwear && is_human_part_visible(H, HIDECROTCH|HIDEJUMPSUIT))
			crotch_exposed = TRUE
		if(crotch_exposed)
			overlay_layer = BODY_FRONT_FRONT_LAYER
	for(var/mutable_appearance/appearance as anything in appearance_list)
		appearance.pixel_y -= 1
		appearance.layer = -overlay_layer
		if(owner?.gender != FEMALE)
			var/matrix/male_scale = matrix()
			male_scale.Scale(0.80, 1)
			appearance.transform = male_scale
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_PANTS)

/datum/sprite_accessory/brand/indentured_womb/get_appearance(obj/item/organ/organ, obj/item/bodypart/bodypart, color_string)
	var/mob/living/carbon/owner
	if(organ)
		owner = organ.owner
	else if(bodypart)
		owner = bodypart.owner || bodypart.original_owner
	var/list/appearance_list = ..()
	if(!appearance_list || !istype(owner, /mob/living/carbon/human/dummy))
		return appearance_list
	for(var/mutable_appearance/appearance as anything in appearance_list.Copy())
		if(appearance.plane == EMISSIVE_PLANE)
			appearance_list -= appearance
	return appearance_list

/datum/sprite_accessory/brand/indentured_taboo
	parent_type = /datum/sprite_accessory/brand/indentured_womb
