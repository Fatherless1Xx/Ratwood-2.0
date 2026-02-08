
/mob/living/carbon/human/Stun(amount, updating = TRUE, ignore_canstun = FALSE)
	amount = dna.species.spec_stun(src,amount)
	return ..()

/mob/living/carbon/human/Knockdown(amount, updating = TRUE, ignore_canstun = FALSE)
	amount = dna.species.spec_stun(src,amount)
	return ..()

/mob/living/carbon/human/Paralyze(amount, updating = TRUE, ignore_canstun = FALSE)
	amount = dna.species.spec_stun(src, amount)
	return ..()

/mob/living/carbon/human/Immobilize(amount, updating = TRUE, ignore_canstun = FALSE)
	amount = dna.species.spec_stun(src, amount)
	return ..()

/mob/living/carbon/human/Unconscious(amount, updating = 1, ignore_canstun = 0)
	amount = dna.species.spec_stun(src,amount)
	if(HAS_TRAIT(src, TRAIT_HEAVY_SLEEPER))
		amount *= rand(1.25, 1.3)
	return ..()

/mob/living/carbon/human/Sleeping(amount, updating = 1, ignore_canstun = 0)
	if(HAS_TRAIT(src, TRAIT_HEAVY_SLEEPER))
		amount *= rand(1.25, 1.3)
	return ..()

/mob/living/carbon/human/cure_husk(list/sources)
	. = ..()
	if(.)
		update_hair()

/mob/living/carbon/human/become_husk(source)
	. = ..()
	if(.)
		update_hair()

/mob/proc/adjust_hygiene(amount)
	return

/mob/living/carbon/human/adjust_hygiene(amount)
	..()
	if(!amount)
		return
	var/old_hygiene = hygiene
	var/new_hygiene = CLAMP(hygiene + amount, 0, HYGIENE_LEVEL_CLEAN)
	if(new_hygiene == old_hygiene)
		return
	hygiene = new_hygiene
	var/old_dirty = (old_hygiene <= HYGIENE_LEVEL_DIRTY)
	var/new_dirty = (new_hygiene <= HYGIENE_LEVEL_DIRTY)
	if(old_dirty != new_dirty)
		update_smell()

/mob/proc/set_hygiene(amount)
	return

/mob/living/carbon/human/set_hygiene(amount)
	var/old_hygiene = hygiene
	var/new_hygiene = CLAMP(amount, 0, HYGIENE_LEVEL_CLEAN)
	if(new_hygiene == old_hygiene)
		return
	hygiene = new_hygiene
	var/old_dirty = (old_hygiene <= HYGIENE_LEVEL_DIRTY)
	var/new_dirty = (new_hygiene <= HYGIENE_LEVEL_DIRTY)
	if(old_dirty != new_dirty)
		update_smell()

/mob/living/carbon/human/set_drugginess(amount)
	..()
//	if(!amount)
//		remove_language(/datum/language/beachbum)

/mob/living/carbon/human/adjust_drugginess(amount)
	..()
//	if(!dna.check_mutation(STONER))
//		if(druggy)
//			grant_language(/datum/language/beachbum)
//		else
//			remove_language(/datum/language/beachbum)
