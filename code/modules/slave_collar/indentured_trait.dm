GLOBAL_LIST_EMPTY(indentured_pet_refs)

SUBSYSTEM_DEF(indentured_trait)
	name = "Indentured Trait"
	flags = SS_NO_FIRE

/datum/controller/subsystem/indentured_trait/Initialize(start_timeofday)
	RegisterSignal(SSdcs, COMSIG_ATOM_ADD_TRAIT, PROC_REF(on_add_trait))
	RegisterSignal(SSdcs, COMSIG_ATOM_REMOVE_TRAIT, PROC_REF(on_remove_trait))
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, PROC_REF(on_job_after_spawn))
	resync_world()
	return ..()

/datum/controller/subsystem/indentured_trait/proc/resync_world()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(HAS_TRAIT(H, TRAIT_INDENTURED))
			apply_indentured(H)
		if(HAS_TRAIT(H, TRAIT_INDENTURE_MASTER))
			ensure_master_ready(H)

/datum/controller/subsystem/indentured_trait/proc/on_add_trait(datum/source, atom/target, trait)
	if(istype(target, /datum/mind))
		var/datum/mind/M = target
		if(M.current && ishuman(M.current))
			on_add_trait(source, M.current, trait)
		return
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(trait == TRAIT_INDENTURED)
		apply_indentured(H)
		log_indentured_change(H, TRUE)
	else if(trait == TRAIT_INDENTURE_MASTER)
		ensure_master_ready(H)

/datum/controller/subsystem/indentured_trait/proc/on_remove_trait(datum/source, atom/target, trait)
	if(istype(target, /datum/mind))
		var/datum/mind/M = target
		if(M.current && ishuman(M.current))
			on_remove_trait(source, M.current, trait)
		return
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(trait == TRAIT_INDENTURED)
		log_indentured_change(H, FALSE)
		clear_indentured(H)
	else if(trait == TRAIT_INDENTURE_MASTER)
		remove_pets_from_master(H)

/datum/controller/subsystem/indentured_trait/proc/log_indentured_change(mob/living/carbon/human/pet, added)
	if(!pet)
		return
	var/msg = "[key_name(pet, TRUE)] [added ? "gained" : "lost"] TRAIT_INDENTURED."
	log_admin(msg)
	message_admins(span_adminnotice(msg))
	log_game(msg)

/datum/controller/subsystem/indentured_trait/proc/on_job_after_spawn(datum/source, datum/job/job, mob/living/carbon/human/spawned, client/player_client)
	if(!ishuman(spawned))
		return
	if(HAS_TRAIT(spawned, TRAIT_INDENTURED))
		apply_indentured(spawned)
	if(HAS_TRAIT(spawned, TRAIT_INDENTURE_MASTER))
		ensure_master_ready(spawned)

/datum/controller/subsystem/indentured_trait/proc/apply_indentured(mob/living/carbon/human/pet)
	if(!pet || QDELETED(pet))
		return
	if(istype(pet, /mob/living/carbon/human/dummy))
		ensure_brand(pet)
		return
	add_indentured_ref(pet)
	ensure_brand(pet)
	RegisterSignal(pet, COMSIG_PARENT_QDELETING, PROC_REF(on_pet_deleted))
	RegisterSignal(pet, COMSIG_LIVING_REVIVE, PROC_REF(on_pet_revive))
	add_pet_to_all_masters(pet)

/datum/controller/subsystem/indentured_trait/proc/clear_indentured(mob/living/carbon/human/pet)
	if(!pet)
		return
	remove_brand(pet)
	remove_pet_from_all_masters(pet)
	remove_indentured_ref(pet)
	UnregisterSignal(pet, COMSIG_PARENT_QDELETING)
	UnregisterSignal(pet, COMSIG_LIVING_REVIVE)

/datum/controller/subsystem/indentured_trait/proc/on_pet_deleted(datum/source, force)
	clear_indentured(source)

/datum/controller/subsystem/indentured_trait/proc/on_pet_revive(datum/source, full_heal, admin_revive)
	SIGNAL_HANDLER
	if(!ishuman(source))
		return
	var/mob/living/carbon/human/pet = source
	if(!HAS_TRAIT(pet, TRAIT_INDENTURED))
		return
	apply_indentured(pet)

/datum/controller/subsystem/indentured_trait/proc/add_indentured_ref(mob/living/carbon/human/pet)
	if(!GLOB.indentured_pet_refs)
		GLOB.indentured_pet_refs = list()
	GLOB.indentured_pet_refs[REF(pet)] = WEAKREF(pet)

/datum/controller/subsystem/indentured_trait/proc/remove_indentured_ref(mob/living/carbon/human/pet)
	if(!GLOB.indentured_pet_refs)
		return
	GLOB.indentured_pet_refs -= REF(pet)

/datum/controller/subsystem/indentured_trait/proc/get_indentured_pets()
	var/list/pets = list()
	if(!GLOB.indentured_pet_refs)
		return pets
	for(var/ref_id in GLOB.indentured_pet_refs.Copy())
		var/datum/weakref/W = GLOB.indentured_pet_refs[ref_id]
		var/mob/living/carbon/human/P = W?.resolve()
		if(P)
			pets += P
		else
			GLOB.indentured_pet_refs -= ref_id
	return pets

/datum/controller/subsystem/indentured_trait/proc/ensure_brand(mob/living/carbon/human/pet)
	var/obj/item/bodypart/chest = pet.get_bodypart(BODY_ZONE_CHEST)
	if(!chest)
		return
	if(chest.bodypart_features)
		for(var/datum/bodypart_feature/feature as anything in chest.bodypart_features)
			if(istype(feature, /datum/bodypart_feature/indentured_brand))
				return
	chest.add_bodypart_feature(new /datum/bodypart_feature/indentured_brand)

/datum/controller/subsystem/indentured_trait/proc/remove_brand(mob/living/carbon/human/pet)
	var/obj/item/bodypart/chest = pet.get_bodypart(BODY_ZONE_CHEST)
	if(!chest || !chest.bodypart_features)
		return
	for(var/datum/bodypart_feature/feature as anything in chest.bodypart_features.Copy())
		if(istype(feature, /datum/bodypart_feature/indentured_brand))
			chest.remove_bodypart_feature(feature)
			return

/datum/controller/subsystem/indentured_trait/proc/add_pet_to_all_masters(mob/living/carbon/human/pet)
	for(var/mob/living/carbon/human/controller in GLOB.human_list)
		if(!HAS_TRAIT(controller, TRAIT_INDENTURE_MASTER))
			continue
		add_pet_to_master(controller, pet)

/datum/controller/subsystem/indentured_trait/proc/remove_pet_from_all_masters(mob/living/carbon/human/pet)
	for(var/mob/living/carbon/human/controller in GLOB.human_list)
		if(!HAS_TRAIT(controller, TRAIT_INDENTURE_MASTER))
			continue
		var/datum/component/collar_master/CM = controller.mind?.GetComponent(/datum/component/collar_master)
		CM?.remove_pet(pet)

/datum/controller/subsystem/indentured_trait/proc/add_pet_to_master(mob/living/carbon/human/controller, mob/living/carbon/human/pet)
	var/datum/component/collar_master/CM = ensure_master_component(controller)
	CM?.add_pet(pet)

/datum/controller/subsystem/indentured_trait/proc/ensure_master_ready(mob/living/carbon/human/controller)
	var/datum/component/collar_master/CM = ensure_master_component(controller)
	if(!CM)
		return
	for(var/mob/living/carbon/human/pet in get_indentured_pets())
		CM.add_pet(pet)

/datum/controller/subsystem/indentured_trait/proc/remove_pets_from_master(mob/living/carbon/human/controller)
	var/datum/component/collar_master/CM = controller?.mind?.GetComponent(/datum/component/collar_master)
	if(!CM)
		return
	for(var/mob/living/carbon/human/pet in get_indentured_pets())
		CM.remove_pet(pet)

/datum/controller/subsystem/indentured_trait/proc/ensure_master_component(mob/living/carbon/human/controller)
	if(!controller?.mind)
		return
	return controller.mind.GetComponent(/datum/component/collar_master) || controller.mind.AddComponent(/datum/component/collar_master)
