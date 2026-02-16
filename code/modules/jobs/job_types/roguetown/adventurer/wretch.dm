// Wretch, soft antagonists. Giving them a significant boon in stats due to their general presence as driving antagonists.
/datum/job/roguetown/wretch
	title = "Wretch"
	flag = WRETCH
	department_flag = WANDERERS
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	allowed_races = RACES_ALL_KINDS
	tutorial = "Somewhere in your lyfe, you fell to the wrong side of civilization. Hounded by the consequences of your actions, you spend your daes prowling the roads for easy marks and loose purses, scraping to get by."
	outfit = null
	outfit_female = null
	display_order = JDO_WRETCH
	show_in_credits = FALSE
	min_pq = 30//60>50>30. What a world. Fingers crossed that folks aren't as bad with it now.
	max_pq = null

	obsfuscated_job = TRUE

	advclass_cat_rolls = list(CTAG_WRETCH = 20)
	PQ_boost_divider = 10
	round_contrib_points = 2

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 1 MINUTES
	virtue_restrictions = list(/datum/virtue/heretic/zchurch_keyholder) //all wretch classes automatically get this
	carebox_table = /datum/carebox_table/wretch
	job_traits = list(TRAIT_STEELHEARTED, TRAIT_OUTLAW, TRAIT_HERESIARCH, TRAIT_SELF_SUSTENANCE, TRAIT_ZURCH)
	job_subclasses = list(
		/datum/advclass/wretch/licker,
		/datum/advclass/wretch/deserter,
		/datum/advclass/wretch/deserter/maa,
		/datum/advclass/wretch/berserker,
		/datum/advclass/wretch/hedgemage,
		/datum/advclass/wretch/necromancer,
		/datum/advclass/wretch/heretic,
		/datum/advclass/wretch/heretic/spy,
		/datum/advclass/wretch/outlaw,
		/datum/advclass/wretch/outlaw/marauder,
		/datum/advclass/wretch/poacher,
		/datum/advclass/wretch/plaguebearer,
		/datum/advclass/wretch/pyromaniac,
		/datum/advclass/wretch/vigilante,
		/datum/advclass/wretch/blackoakwyrm,
		/datum/advclass/wretch/antipope,
	)

/datum/job/roguetown/wretch/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		// Assign wretch antagonist datum so wretches appear in antag list
		if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/wretch))
			var/datum/antagonist/new_antag = new /datum/antagonist/wretch()
			H.mind.add_antag_datum(new_antag)

// Proc for wretch to select a bounty
/proc/wretch_select_bounty(mob/living/carbon/human/H)
	var/wanted = input(H, "Are you wanted by the kingdom?", "You will be more skilled from your experience") as anything in list("Yes", "No")
	if(wanted == "No") 
		to_chat(src, span_warning("I am still relatively new to the group. My crimes have gone unnoticed so far, but I lack experience."))
		return null
	var/bounty_poster = input(H, "Who placed a bounty on you?", "Bounty Poster") as anything in list("The Justiciary of The Vale", "The Grenzelhoftian Holy See", "The Otavan Orthodoxy")
	// Felinid said we should gate it at 100 or so on at the lowest, so that wretch cannot ezmode it.
	var/bounty_severity = input(H, "How severe are your crimes?", "Bounty Amount") as anything in list("Misdeed", "Harm towards lyfe", "Horrific atrocities")
	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	var/bounty_total = rand(100, 400) // Just in case
	var/my_crime = input(H, "What is your crime?", "Crime") as text|null
	if (!my_crime)
		my_crime = "crimes against the Crown"
	switch(bounty_severity)
		if("Misdeed")
			bounty_total = rand(100, 200)
		if("Harm towards lyfe")
			bounty_total = rand(200, 300)
		if("Horrific atrocities")
			bounty_total = rand(300, 400) // Let's not make it TOO profitable
			if(bounty_poster == "The Justiciary of The Vale")
				GLOB.outlawed_players += H.real_name
			else
				GLOB.excommunicated_players += H.real_name
	if(bounty_severity == "Misdeed")
		add_bounty_obscure(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, FALSE, my_crime, bounty_poster)
	else if(bounty_severity == "Harm towards lyfe")
		add_bounty_noface(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, FALSE, my_crime, bounty_poster)
	else
		add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, FALSE, my_crime, bounty_poster)
		var/skillbuff = input(H, "Your experience grants you a boon", "Choose An Attribute") as anything in list("Strength", "Perception", "Intelligence", "Constitution", "Willpower", "Speed")
		switch(skillbuff)
			if("Strength")
				H.change_stat(STATKEY_STR, 1)
			if("Perception")
				H.change_stat(STATKEY_PER, 1)
			if("Intelligence")
				H.change_stat(STATKEY_INT, 1)
			if("Constitution")
				H.change_stat(STATKEY_CON, 1)
			if("Willpower")
				H.change_stat(STATKEY_WIL, 1)
			if("Speed")
				H.change_stat(STATKEY_SPD, 1)
	to_chat(H, span_danger("You are playing an Antagonist role. By choosing to spawn as a Wretch, you are expected to actively create conflict with other players regardless of bounty status. Failing to play this role with the appropriate gravitas may result in punishment for Low Roleplay standards."))

/proc/update_wretch_slots()
	var/datum/job/wretch_job = SSjob.GetJob("Wretch")
	if(!wretch_job)
		return

	var/player_count = length(GLOB.joined_player_list)
	var/slots = 5

	//Add 1 slot for every 10 players over 30. Less than 40 players, 5 slots. 40 or more players, 6 slots. 50 or more players, 7 slots - etc.
	if(player_count > 40)
		var/extra = floor((player_count - 40) / 10)
		slots += extra

	//5 slots minimum, 10 maximum.
	slots = min(slots, 10)

	wretch_job.total_positions = slots
	wretch_job.spawn_positions = slots
