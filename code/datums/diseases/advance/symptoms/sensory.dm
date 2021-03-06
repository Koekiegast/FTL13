/*
//////////////////////////////////////
Sensory-Restoration
	Very very very very noticable.
	Lowers resistance tremendously.
	Decreases stage speed tremendously.
	Decreases transmittablity tremendously.
	Fatal.
Bonus
	The body generates Sensory restorational chemicals.
	inacusiate for ears
	antihol for removal of alcohol
	synaphydramine to purge sensory hallucigens and histamine based impairment
	mannitol to kickstart the mind

//////////////////////////////////////
*/
/datum/symptom/sensory_restoration
	name = "Sensory Restoration"
	stealth = -1
	resistance = -4
	stage_speed = -4
	transmittable = -3
	level = 5
	severity = 0
	symptom_delay_min = 5
	symptom_delay_max = 10
	var/purge_alcohol = FALSE
	var/brain_heal = FALSE

/datum/symptom/sensory_restoration/Start(datum/disease/advance/A)
	..()
	if(A.properties["resistance"] >= 6) //heal brain damage
		brain_heal = TRUE
	if(A.properties["transmittable"] >= 8) //purge alcohol
		purge_alcohol = TRUE

/datum/symptom/sensory_restoration/Activate(var/datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	if(A.stage >= 2)
		M.restoreEars()

	if(A.stage >= 3)
		M.dizziness = max(0, M.dizziness - 2)
		M.drowsyness = max(0, M.drowsyness - 2)
		M.slurring = max(0, M.slurring - 2)
		M.confused = max(0, M.confused - 2)
		if(purge_alcohol)
			M.reagents.remove_all_type(/datum/reagent/consumable/ethanol, 3)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				H.drunkenness = max(H.drunkenness - 5, 0)

	if(A.stage >= 4)
		M.drowsyness = max(0, M.drowsyness - 2)
		if(M.reagents.has_reagent("mindbreaker"))
			M.reagents.remove_reagent("mindbreaker", 5)
		if(M.reagents.has_reagent("histamine"))
			M.reagents.remove_reagent("histamine", 5)
		M.hallucination = max(0, M.hallucination - 10)

	if(brain_heal && A.stage >= 5)
		M.adjustBrainLoss(-3)