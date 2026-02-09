/datum/advclass/ogre/warlord
	name = "Warlord" 
	tutorial = "A great war horn sounds from the bog land, the call of war from a monster of noble blood."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/ogre)
	outfit = /datum/outfit/job/roguetown/ogre/warlord
	class_select_category = CLASS_CAT_OGRE
	category_tags = list(CTAG_OGRE)
	cmode_music = 'sound/music/combat_highgrain.ogg'
	maximum_possible_slots = 1

	traits_applied = list(TRAIT_BASHDOORS, TRAIT_STEELHEARTED, TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN, TRAIT_CALTROPIMMUNE, TRAIT_STRONGBITE, TRAIT_MEDIUMARMOR) //strongbite might be funny
	subclass_stats = list( 
		STATKEY_STR = 3, 
		STATKEY_CON = 4,
		STATKEY_WIL = 3,
	)

	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	) 

/datum/outfit/job/roguetown/ogre/warlord/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/warlord)
		to_chat(H, span_warning("A great war horn sounds from the bog land, the call of war from a monster of noble blood."))
		shoes = /obj/item/clothing/shoes/roguetown/armor/ogre
		shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ogre
		neck = /obj/item/clothing/neck/roguetown/gorget/ogre
		pants = /obj/item/clothing/under/roguetown/chainlegs/ogre
		head = /obj/item/clothing/head/roguetown/helmet/heavy/ogre
		gloves = /obj/item/clothing/gloves/roguetown/plate/ogre
		wrists = /obj/item/clothing/wrists/roguetown/bracers/ogre
		belt = /obj/item/storage/belt/rogue/leather/ogre
		armor = /obj/item/clothing/suit/roguetown/armor/plate/half/ogre
		beltr = /obj/item/rogueweapon/huntingknife/cleaver/ogre
		backr = /obj/item/storage/backpack/rogue/satchel
		backpack_contents = list(
			/obj/item/rogueweapon/mace/cudgel/ogre = 1,
			/obj/item/rope/chain = 1,
			/obj/item/flashlight/flare/torch/lantern = 1
		)
		var/list/weapons = list(
			"Big Stick",
			"Choppa",
			"None"
		)
		var/weaponchoice = input(H,"Choose your weapon.", "WEAPON SELECTION") as null|anything in weapons
		switch(weaponchoice)
			if("Choppa")
				backl = /obj/item/rogueweapon/greatsword/zwei/ogre
			if("None")
				backl = null
			else
				backl = /obj/item/rogueweapon/mace/goden/steel/ogre

/obj/effect/proc_holder/spell/self/convertrole/warlord
	name = "Recruit Follower"
	new_role = "Warlord's Recruit"
	overlay_state = "recruit_templar"
	recruitment_faction = "War Party"
	recruitment_message = "Join my warband, %RECRUIT! For blood and gold!"
	accept_message = "Blood and gold!"
	refuse_message = "I serve no monsters!"
