///This type allowss for customizable terrain generation based on a set of layers,
/datum/terrain_generator

	///List of all the turfs that are included in terrain generation
	var/list/turf/turfs_to_generate_on = list()

	///The map generator modules that we will generate and sync to.
	var/list/datum/terrain_generator_layer/layers

	var/buildmode_name = "Undocumented"

/datum/terrain_generator/New()
	..()
	if(buildmode_name == "Undocumented")
		buildmode_name = copytext_char("[type]", 20) // / d a t u m / m a p g e n e r a t o r / = 20 characters.

/datum/terrain_generator/Destroy(force)
	. = ..()

///This proc will be ran by areas on Initialize, and provides the areas turfs as argument to allow for generation.
/datum/terrain_generator/proc/generate_terrain(list/turfs, area/generate_in)
	return

/// Populate terrain with flora, fauna, features and basically everything that isn't a turf.
/datum/terrain_generator/proc/populate_terrain(list/turfs, area/generate_in)
	return

//Defines the region the map represents, sets map
//Returns the map
/datum/terrain_generator/proc/defineRegion(turf/Start, turf/End, replace = 0)
	if(!checkRegion(Start, End))
		return 0

	if(replace)
		undefineRegion()
	map |= block(Start, End)
	return map

//Empties the map list, he's dead jim.
/datum/terrain_generator/proc/undefineRegion()
	map = list() //bai bai


//Checks for and Rejects bad region coordinates
//Returns 1/0
/datum/terrain_generator/proc/checkRegion(turf/Start, turf/End)
	if(!Start || !End)
		return FALSE //Just bail

	if(Start.x > world.maxx || End.x > world.maxx)
		return FALSE
	if(Start.y > world.maxy || End.y > world.maxy)
		return FALSE
	if(Start.z > world.maxz || End.z > world.maxz)
		return FALSE
	return TRUE


//Requests the TerrainGeneratorLayer(s) to (re)generate
/datum/terrain_generator/proc/generate()
	if(!layers || !layers.len)
		return
	for(var/datum/map_generator_module/mod as anything in modules)
		INVOKE_ASYNC(mod, TYPE_PROC_REF(/datum/map_generator_module, generate))

