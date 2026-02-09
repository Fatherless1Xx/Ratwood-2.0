// Ogre-specific equipment, recipes, and cosmetic accessories.
// Kept in a standalone file to avoid invasive edits across many systems.

/obj/item/rogueweapon/greataxe/steel/doublehead/graggar/ogre
	name = "executioner's folly"
	desc = "Attempts have been made to cut off an ogre's head. Those who try forget how easily they break their chains, and how thick their necks are."
	icon_state = "ogre_axe"
	force = 20
	force_wielded = 40
	icon = 'icons/roguetown/weapons/ogre_64.dmi'
	max_blade_int = 200
	icon_x_offset = -4
	icon_y_offset = 2

/obj/item/rogueweapon/greataxe/steel/doublehead/graggar/ogre/pickup(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_HORDE))
		to_chat(user, "<font color='red'>WEAK HANDS CANNOT HANDLE MY STRENGTH. BE PUNISHED.</font>")
		user.adjust_fire_stacks(5)
		user.ignite_mob()
		user.Stun(10)
	..()

/obj/item/rogueweapon/mace/cudgel/ogre
	name = "Head Knockah"
	desc = "A bell ringer that's been repurposed by a crafty set of hands, its size can only be wielded effectively by a giant."
	force = 25
	icon = 'icons/roguetown/weapons/ogre_64.dmi'
	icon_state = "ogre_cudgel"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	minstr = 13
	pixel_y = -16
	pixel_x = -16
	bigboy = TRUE
	icon_x_offset = -4
	icon_y_offset = 4

/obj/item/rogueweapon/huntingknife/cleaver/ogre
	name = "Meat Choppah"
	desc = "Any good cook needs to prep their meat. Chop it, slice it, maybe even kill it before you do all that. Meant for the hands of a giant."
	icon = 'icons/roguetown/weapons/ogre_64.dmi'
	icon_state = "ogre_cleaver"
	slot_flags = ITEM_SLOT_HIP
	force = 25
	wdefense = 4
	minstr = 13
	pixel_y = -16
	pixel_x = -16
	bigboy = TRUE
	icon_x_offset = -4
	icon_y_offset = 2

/obj/item/rogueweapon/greatsword/zwei/ogre
	name = "Better Sword"
	desc = "The mind of an ogre does not see trash in a field of discarded swords and corpses. He sees material to make a new weapon, with a light snack."
	icon = 'icons/roguetown/weapons/ogre_64.dmi'
	icon_state = "ogre_sword"
	slot_flags = ITEM_SLOT_BACK
	minstr = 15
	smelt_bar_num = 2
	force = 20
	force_wielded = 35
	max_blade_int = 250
	max_integrity = 260
	icon_y_offset = 2

/obj/item/rogueweapon/mace/goden/steel/ogre
	name = "Mace of Malum"
	desc = "Sometimes an ogre comes across an abandoned blacksmith's forge, and finds an intact anvil. Few minds but an ogre's can think to use a tool of pure creation to beat people to paste."
	icon = 'icons/roguetown/weapons/ogre_64.dmi'
	icon_state = "ogre_anvil"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	force = 20
	force_wielded = 40
	possible_item_intents = list(/datum/intent/mace/strike)
	gripped_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash, /datum/intent/effect/daze)
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2
	minstr = 15
	force_wielded = 35
	max_integrity = 260
	icon_x_offset = -9
	icon_y_offset = 8

/obj/item/rogueweapon/mace/goden/steel/ogre/graggar
	name = "Ogre's Mace"
	desc = "Only a giant can effectively make use of this weapon. It has fed one at the expense of many lives."
	icon_state = "ogre_mace"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	force = 25
	force_wielded = 45
	gripped_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash, /datum/intent/effect/daze)
	smelt_bar_num = 2
	minstr = 15
	force_wielded = 35
	max_blade_int = 250
	max_integrity = 280
	icon_x_offset = -4
	icon_y_offset = 3

/obj/item/rogueweapon/mace/goden/steel/ogre/graggar/pickup(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_HORDE))
		to_chat(user, "<font color='red'>WEAK HANDS CANNOT TOUCH ME. PUNISHMENT FOR YOU!</font>")
		user.adjust_fire_stacks(5)
		user.ignite_mob()
		user.Stun(40)
	..()

/obj/item/undies/ogre
	name = "big briefs"
	desc = "An absolute necessity."
	icon_state = "under"
	icon = 'icons/mob/sprite_accessory/big_underwear.dmi'
	sprite_acc = /datum/sprite_accessory/underwear/big_briefs

/obj/item/undies/bikini/ogre
	name = "big bikini"
	icon_state = "ogre_bra"
	icon = 'icons/mob/sprite_accessory/big_underwear.dmi'
	covers_breasts = TRUE
	sprite_acc = /datum/sprite_accessory/underwear/big_bikini

/datum/sprite_accessory/underwear/big_briefs
	name = "Big briefs"
	icon_state = "under"
	icon = 'icons/mob/sprite_accessory/big_underwear.dmi'
	underwear_type = /obj/item/undies/ogre

/datum/sprite_accessory/underwear/big_briefs/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(is_species(owner, /datum/species/ogre))
		return "under"
	if(owner.gender == FEMALE)
		return "ogre_bra"
	return "under"

/datum/sprite_accessory/underwear/big_bikini
	name = "Big bikini"
	icon_state = "ogre_bra"
	icon = 'icons/mob/sprite_accessory/big_underwear.dmi'
	underwear_type = /obj/item/undies/bikini/ogre
	hides_breasts = TRUE

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ogre
	name = "giant hauberk"
	desc = "A gigantic chainmail shirt, absurd to even think it would fit someone of normal size."
	icon = 'icons/roguetown/clothing/ogre_items.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/32x64/ogre_onmob_sleeves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
	icon_state = "ogre_maille"
	allowed_race = OGRE_RACE_TYPES

/obj/item/clothing/suit/roguetown/armor/plate/half/ogre
	name = "giant cuirass"
	desc = "An absurdly large piece of armor, meant for an absurdly large man."
	icon = 'icons/roguetown/clothing/ogre_items.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
	icon_state = "ogre_cuirass"
	max_integrity = 600
	allowed_race = OGRE_RACE_TYPES

/obj/item/clothing/cloak/apron/ogre
	name = "giant apron"
	desc = "An apron of such grand size could take the brunt of a whole spilled soup pot and still leave the cook dry."
	icon = 'icons/roguetown/clothing/ogre_items.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
	icon_state = "cookapron"
	allowed_race = OGRE_RACE_TYPES

/obj/item/clothing/shoes/roguetown/armor/ogre
	name = "giant plate boots"
	desc = "When giants march to war, they need two things above all else. Something to eat, and boots to stomp around."
	icon = 'icons/roguetown/clothing/ogre_items.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
	icon_state = "ogre_plateboots"
	allowed_race = OGRE_RACE_TYPES
	max_integrity = 250
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)

/obj/item/clothing/shoes/roguetown/boots/ogre
	name = "oversized boots"
	desc = "The hardest working set of boots this side of the mountains."
	icon = 'icons/roguetown/clothing/ogre_items.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/32x64/ogre_onmob_sleeves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
	icon_state = "ogre_boots"
	allowed_race = OGRE_RACE_TYPES
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)
	max_integrity = 150

/obj/item/clothing/gloves/roguetown/plate/ogre
	name = "oversized gauntlets"
	desc = "Huge, iron gauntlets - the size of a human head."
	icon = 'icons/roguetown/clothing/ogre_items.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/32x64/ogre_onmob_sleeves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
	icon_state = "ogregrabbers"
	allowed_race = OGRE_RACE_TYPES
	prevent_crits = list(BCLASS_CHOP, BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)

/obj/item/clothing/gloves/roguetown/leather/ogre
	name = "oversized gloves"
	desc = "Huge, leather gloves - the size of a human head."
	icon = 'icons/roguetown/clothing/ogre_items.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/32x64/ogre_onmob_sleeves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
	icon_state = "ogreglove"
	allowed_race = OGRE_RACE_TYPES
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT)

/obj/item/clothing/head/roguetown/cookhat/ogre
	name = "giant chef's hat"
	desc = "This is the badge of a true gourmand. None should ever look upon you with anything less than utter respect."
	icon = 'icons/roguetown/clothing/ogre_items.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
	icon_state = "cookhat"
	item_state = "cookhat"
	allowed_race = OGRE_RACE_TYPES

/obj/item/clothing/head/roguetown/helmet/heavy/ogre
	name = "giant iron barbute"
	desc = "When you have a big head, it needs a big helmet. This one is modeled after old imperial armor designs."
	icon = 'icons/roguetown/clothing/ogre_items.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
	icon_state = "merchelmet"
	item_state = "merchelmet"
	allowed_race = OGRE_RACE_TYPES
	flags_inv = HIDEEARS | HIDEHAIR

/obj/item/clothing/head/roguetown/helmet/heavy/graggar/ogre
	name = "graggar's champion helmet"
	desc = "The mark of Graggar's rampage, this is the helmet of his greatest warrior."
	icon = 'icons/roguetown/clothing/ogre_items.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
	icon_state = "warlhelmet"
	item_state = "warlhelmet"
	allowed_race = OGRE_RACE_TYPES
	flags_inv = HIDEEARS | HIDEHAIR

/obj/item/clothing/neck/roguetown/gorget/ogre
	name = "giant gorget"
	desc = "For the hardest working neck in the province, since you know people are going to target it first."
	icon = 'icons/roguetown/clothing/ogre_items.dmi'
	icon_state = "ogre_gorget"
	allowed_race = OGRE_RACE_TYPES
	max_integrity = 300

/obj/item/clothing/under/roguetown/tights/ogre
	name = "giant pants"
	desc = "These pants provide a vital service to society."
	icon = 'icons/roguetown/clothing/ogre_items.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/32x64/ogre_onmob_sleeves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
	icon_state = "ogre_pants"
	allowed_race = OGRE_RACE_TYPES
	max_integrity = 250

/obj/item/clothing/under/roguetown/chainlegs/ogre
	name = "giant chain chausses"
	desc = "The amount of chainmail used for these could make a regular sized hauberk for a humble town guard."
	icon = 'icons/roguetown/clothing/ogre_items.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/32x64/ogre_onmob_sleeves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
	icon_state = "ogre_chain"
	allowed_race = OGRE_RACE_TYPES

/obj/item/clothing/suit/roguetown/shirt/ogre
	name = "giant shirt"
	desc = "The difference between you and a more uncivilized giant is that you got this fancy dyed cloth that means you're cultured and important."
	icon = 'icons/roguetown/clothing/ogre_items.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/32x64/ogre_onmob_sleeves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
	icon_state = "ogre_shirt"
	allowed_race = OGRE_RACE_TYPES
	max_integrity = 250

/obj/item/storage/belt/rogue/leather/ogre
	name = "giant belt"
	desc = "When you have to tighten a belt of this size, best start keeping your tastiest allies close."
	icon = 'icons/roguetown/clothing/ogre_items.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
	icon_state = "ogre_belt"

/obj/item/clothing/wrists/roguetown/bracers/ogre
	name = "thick bracers"
	desc = "Normal humans can fit a leg through this hunk of steel."
	icon = 'icons/roguetown/clothing/ogre_items.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/32x64/ogre_onmob_sleeves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
	icon_state = "ogre_bracers"
	allowed_race = OGRE_RACE_TYPES

/datum/crafting_recipe/roguetown/sewing/giant_shirt
	name = "giant shirt"
	reqs = list(
		/obj/item/natural/cloth = 4,
		/obj/item/natural/fibers = 2,
	)
	result = /obj/item/clothing/suit/roguetown/shirt/ogre

/datum/crafting_recipe/roguetown/sewing/giant_pants
	name = "giant pants"
	reqs = list(
		/obj/item/natural/cloth = 4,
		/obj/item/natural/fibers = 2,
	)
	result = /obj/item/clothing/under/roguetown/tights/ogre

/datum/crafting_recipe/roguetown/leather/gloves_ogre
	name = "big leather gloves"
	result = /obj/item/clothing/gloves/roguetown/leather/ogre
	reqs = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 1,
	)
	craftdiff = 1

/datum/crafting_recipe/roguetown/leather/boots_ogre
	name = "big leather boots"
	result = /obj/item/clothing/shoes/roguetown/boots/ogre
	reqs = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 1,
	)
	craftdiff = 1

/datum/crafting_recipe/roguetown/leather/container/beltogre
	name = "colossal leather belt"
	result = /obj/item/storage/belt/rogue/leather/ogre
	reqs = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/natural/fibers = 2,
	)

/datum/anvil_recipe/armor/iron/ogrebreastplate
	name = "Ogre breastplate (+2 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/half/ogre

/datum/anvil_recipe/armor/iron/ogremaille
	name = "Ogre maille (+3 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ogre

/datum/anvil_recipe/armor/iron/ogrechausses
	name = "Ogre chain chausses (+3 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/clothing/under/roguetown/chainlegs/ogre

/datum/anvil_recipe/armor/iron/ogrebarbute
	name = "Ogre barbute (+2 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/ogre

/datum/anvil_recipe/armor/iron/ogregloves
	name = "Ogre plate gloves (+2 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/clothing/gloves/roguetown/plate/ogre

/datum/anvil_recipe/armor/iron/ogrebracers
	name = "Ogre plate bracers (+2 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/clothing/wrists/roguetown/bracers/ogre

/datum/anvil_recipe/armor/iron/ogregorget
	name = "Ogre plate gorget (+2 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/clothing/neck/roguetown/gorget/ogre

/obj/effect/landmark/start/ogre
	name = "Ogre"
	icon_state = "arrow"
