/var/list/lighting_update_lights    = list()    // List of light sources queued for update.
/var/list/lighting_update_overlays  = list()    // List of ligting overlays queued for update.

/var/lighting_processing            = 1

/*
/world/New()
	. = ..()
	lighting_start_process()
*/

/mob/verb/lighting_start_process()
	set waitfor = 0
	while(lighting_processing)
		sleep(LIGHTING_INTERVAL)
		lighting_process()

/proc/lighting_process()
	for(var/datum/light_source/L in lighting_update_lights)
		. = L.check()
		if(L.destroyed || .)
			L.remove_lum()
			if(!L.destroyed)
				L.apply_lum()

		else if(L.vis_update)	// We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update   = 0
		L.needs_update = 0

	for(var/atom/movable/lighting_overlay/O in lighting_update_lights)
		//O.update_overlay()
		//O.needs_update = 0
