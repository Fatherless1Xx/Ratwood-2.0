/*
Firstly, the
*/
/obj/item/rogueweapon/palantir
	name = "Palantir"
	desc = "An arcyne compass, runed and imbued with energy. That is, of course, to say that this is able to detect leyline intersection points."
	icon = 'icons/roguetown/weapons/stationary/bombard.dmi'
	icon_state = "palantir"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	var/last_x = "UNKNOWN"
	var/last_y = "UNKNOWN"

/obj/item/rogueweapon/palantir/examine(mob/user)
	. = ..()
	. += "<small>Last 'X' coordinate recorded: <span class='warning'>[last_x]</span> <br>\
		Last 'Y' coordinate recorded: <span class='warning'>[last_y]</span></small>"

/obj/item/rogueweapon/palantir/afterattack(atom/A, mob/living/user, adjacent, params) //handles coord obtaining
	if(!HAS_TRAIT(user, TRAIT_FUSILIER))
		to_chat(user, "<span class='warning'>You've no idea as to how to predict a firing solution!</span>")
		return
	to_chat(user, "Calculating coordinates. Stand still.")
	if(do_after(user, 12 SECONDS, src))
		A = get_turf(A)
		last_x = obfuscate_x(A.x)
		last_y = obfuscate_y(A.y)
		to_chat(user, "COORDINATES OF TARGET. LONGITUDE [last_x]. LATITUDE [last_y].")
	else
		to_chat(user, "<span class='warning'>You must remain still!</span>")

/*
Cannonballs below.
Take a guess, yeah?
*/
//This is a 'solid shot'. Does nothing, as of now.
/obj/item/cannonball
	name = "\improper cannonball (SOL)"
	desc = "A hefty cannonball. Looks fairly solid."
	icon = 'icons/roguetown/weapons/stationary/bombard.dmi'
	icon_state = "cball"

/obj/item/cannonball/proc/detonate(turf/T)
	forceMove(T)

//HE
/obj/item/cannonball/explosive
	name = "\improper cannonball (HE)"
	desc = "A hefty cannonball. It's hot to the touch, as if it'll explode just by dropping it."
	icon_state = "cball"

/obj/item/cannonball/explosive/detonate(turf/T)
	..()
	explosion(T, 2, 4, 6, 8)

//SMOKE
/obj/item/cannonball/smoke
	name = "\improper cannonball (SMK)"
	desc = "A hefty cannonball. This one feels as if it's hollow."
	icon_state = "cball_smk"

/obj/item/cannonball/smoke/detonate(turf/T)
	..()
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(4, T, 0)
	smoke.start()
	explosion(T, 0, 0, 1, 7)//Generic explosion outside of explosive canisters.

//CANISTER
/obj/item/cannonball/canister
	name = "\improper cannonball (FLK)"
	desc = "A canister shell, meant to be fired out of a bombard. Nasty thing, outlawed in all reasonable realms of the land..."
	icon_state = "cball_smk"

/obj/item/cannonball/canister/detonate(turf/T)
	..()
	canister_detonate()

/*
The canister effect, when using canister shot or adjacent stuff.
*/
/obj/item/cannonball/proc/canister_detonate(atom/target)
	var/datum/component/shrapnel/canister_shrapnel = new /datum/component/shrapnel()
	target = get_turf(src)
	canister_shrapnel.projectile_type = /obj/projectile/canister_shrap
	canister_shrapnel.radius = 6
	canister_shrapnel.do_shrapnel(src, target)

/obj/projectile/canister_shrap
	name = "canister shrapnel"
	icon_state = "bullet"
	damage = 15
	range = 12
	pass_flags = PASSTABLE | PASSGRILLE
	armor_penetration = 80
	damage_type = BRUTE
	woundclass = BCLASS_PICK
	flag = "bullet"
	hitsound_wall = "ricochet"
	speed = 2
