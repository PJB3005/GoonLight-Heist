/mob/verb/corner_debug()
	src << "Coordinates: [x], [y]"
	var/turf/T = get_turf(src)
	for(var/datum/lighting_corner/L in T.corners)
		src << "Lighting corner \ref[L]: dir: [dir2text(LIGHTING_CORNER_DIAGONAL[T.corners.Find(L)])], x: [L.x], y: [L.y], lum_r: [L.lum_r], lum_g: [L.lum_g], lum_b: [L.lum_b]"

/proc/dir2text(var/dir)
	ASSERT(dir)
	switch(dir)
		if(NORTH)
			return "NORTH"
		if(SOUTH)
			return "SOUTH"
		if(EAST)
			return "EAST"
		if(WEST)
			return "WEST"

		if(NORTHEAST)
			return "NORTHEAST"
		if(SOUTHEAST)
			return "SOUTHEAST"
		if(SOUTHWEST)
			return "SOUTHWEST"
		if(NORTHWEST)
			return "NORTHWEST"
