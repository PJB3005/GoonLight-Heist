// So the thing is, making things like lighting overlay data persist when a turf gets replaced is sort of hard...
// As such, whenever you're causing a turf's type to change, use this proc to do it.
// If you don't, the lighting engine will not approve of your shenanigans.
// Still unsure whether this proc should be under /Lighting or under /helpers...
/turf/proc/change_turf(var/new_type)
	// Back all this data up, so we can set it after the turf replace.
	// If you're wondering how this proc'll keep running since the turf should be "deleted":
	// BYOND never deletes turfs, when you "delete" a turf, it actually morphs the turf into a new one.
	// Running procs do NOT get stopped due to this.
	var/l_overlay     = lighting_overlay // Not even a need to cast this, honestly.
	var/affect_lights = affecting_lights
	var/l_corners     = corners
	var/old_dynamic   = dynamic_lighting

	// Create the new turf, replacing us.
	new new_type(src)

	lighting_overlay  = l_overlay
	affecting_lights  = affect_lights
	corners           = l_corners

	if(old_dynamic != dynamic_lighting)
		if(dynamic_lighting)
			lighting_build_overlay()

		else
			lighting_clear_overlay()
