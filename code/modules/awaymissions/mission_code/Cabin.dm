
/*Cabin areas*/
/area/awaymission/cabin
	name = "Cabin"
	icon_state = "away2"
	requires_power = TRUE
	static_lighting = TRUE

/area/awaymission/cabin/snowforest
	name = "Snow Forest"
	icon_state = "away"

/area/awaymission/cabin/snowforest/sovietsurface
	name = "Snow Forest"
	icon_state = "awaycontent29"
	requires_power = FALSE

/area/awaymission/cabin/lumbermill
	name = "Lumbermill"
	icon_state = "away3"
	requires_power = FALSE

/area/awaymission/cabin/caves/sovietcave
	name = "Soviet Bunker"
	icon_state = "awaycontent4"

/area/awaymission/cabin/caves
	name = "North Snowdin Caves"
	icon_state = "awaycontent15"
	static_lighting = TRUE

/area/awaymission/cabin/caves/mountain
	name = "North Snowdin Mountains"
	icon_state = "awaycontent24"

/obj/structure/firepit
	name = "firepit"
	desc = "Warm and toasty."
	icon = 'icons/obj/fluff/fireplace.dmi'
	icon_state = "firepit-active"
	density = FALSE
	var/active = TRUE

/obj/structure/firepit/Initialize(mapload)
	. = ..()
	toggleFirepit()

/obj/structure/firepit/interact(mob/living/user)
	if(active)
		active = FALSE
		toggleFirepit()

/obj/structure/firepit/attackby(obj/item/W,mob/living/user,list/modifiers)
	if(!active)
		var/msg = W.ignition_effect(src, user)
		if(msg)
			active = TRUE
			visible_message(msg)
			toggleFirepit()
		else
			return ..()
	else
		W.fire_act()

/obj/structure/firepit/proc/toggleFirepit()
	active = !active
	if(active)
		set_light(8)
		icon_state = "firepit-active"
	else
		set_light(0)
		icon_state = "firepit"

/obj/structure/firepit/extinguish()
	. = ..()
	if(active)
		active = FALSE
		toggleFirepit()

/obj/structure/firepit/fire_act(exposed_temperature, exposed_volume)
	if(!active)
		active = TRUE
		toggleFirepit()



//other Cabin Stuff//

/obj/machinery/recycler/lumbermill
	name = "lumbermill saw"
	desc = "Faster then the cartoons!"
	obj_flags = CAN_BE_HIT | EMAGGED
	item_recycle_sound = 'sound/items/weapons/chainsawhit.ogg'

/obj/machinery/recycler/lumbermill/recycle_item(obj/item/grown/log/L)
	if(!istype(L))
		return
	else
		var/potency = L.seed.potency
		..()
		new L.plank_type(src.loc, 1 + round(potency / 25))

/obj/structure/ladder/unbreakable/rune
	name = "\improper Teleportation Rune"
	desc = "Could lead anywhere."
	icon = 'icons/obj/antags/cult/rune.dmi'
	icon_state = "1"
	color = rgb(0,0,255)

/obj/structure/ladder/unbreakable/rune/Initialize(mapload)
	AddElement(/datum/element/update_icon_blocker)
	return ..()

/obj/structure/ladder/unbreakable/rune/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(up)
		context[SCREENTIP_CONTEXT_LMB] = "Warp up"
	if(down)
		context[SCREENTIP_CONTEXT_RMB] = "Warp down"
	return CONTEXTUAL_SCREENTIP_SET

/obj/structure/ladder/unbreakable/rune/show_initial_fluff_message(mob/user, going_up)
	user.balloon_alert_to_viewers("activating...")

/obj/structure/ladder/unbreakable/rune/show_final_fluff_message(mob/user, going_up)
	visible_message(span_notice("[user] activates [src] and teleports away."))
	user.balloon_alert_to_viewers("warped in")

/obj/structure/ladder/unbreakable/rune/use(mob/user, going_up = TRUE)
	if(!IS_WIZARD(user))
		..()
