// Because we can control each corner of every lighting overlay.
// And corners get shared between multiple turfs (unless you're on the corners of the map, then 1 corner doesn't).
// For the record: these should never ever ever be deleted, even if the turf doesn't have dynamic lighting.

// This list is what the code that assigns corners listens to, the order in this list is the order in which corners are added to the /turf/corners list.
/var/list/LIGHTING_CORNER_DIAGONAL = list(NORTHEAST, SOUTHEAST, SOUTHWEST, NORTHWEST)

/datum/lighting_corner
	var/list/turf/masters = list()
	// var/list/datum/light_source/affecting_lights = list()

	// Mostly here for simplicity.
	var/x             = 0
	var/y             = 0

	var/lum_r         = 0
	var/lum_g         = 0
	var/lum_b         = 0

/datum/lighting_corner/New(var/turf/new_turf, var/diagonal)
	. = ..()

	masters[new_turf] = turn(diagonal, 180)

	var/vertical   = diagonal & ~(diagonal - 1) // The horizontal directions (4 and 8) are bigger than the vertical ones (1 and 2), so we can reliably say the lsb is the horizontal direction.
	var/horizontal = diagonal & ~vertical       // Now that we know the horizontal one we can get the vertical one.

	// world << "Corner \ref[src] created: turf \ref[new_turf] ([new_turf.x], [new_turf.y]), diagonal: [dir2text(diagonal)] (horizontal: [dir2text(horizontal)], vertical: [dir2text(vertical)])"

	x = new_turf.x + (horizontal == EAST  ? 0.5 : -0.5)
	y = new_turf.y + (vertical   == NORTH ? 0.5 : -0.5)

	// My initial plan was to make this loop through a list of all the dirs (horizontal, vertical, diagonal).
	// Issue being that the only way I could think of doing it was very messy, slow and honestly overengineered.
	// So we'll have this hardcode instead.
	var/turf/T
	var/i

	// Diagonal one is easy.
	T = get_step(new_turf, diagonal)
	if(T) // In case we're on the map's border.
		masters[T]   = diagonal
		i            = LIGHTING_CORNER_DIAGONAL.Find(turn(diagonal, 180))
		T.corners[i] = src

	// Now the horizontal one.
	T = get_step(new_turf, horizontal)
	if(T) // Ditto.
		masters[T]   = ((T.x > x) ? EAST : WEST) | ((T.y > y) ? NORTH : SOUTH) // Get the dir based on coordinates.
		i            = LIGHTING_CORNER_DIAGONAL.Find(turn(masters[T], 180))
		T.corners[i] = src

	// And finally the vertical one.
	T = get_step(new_turf, vertical)
	if(T)
		masters[T]   = ((T.x > x) ? EAST : WEST) | ((T.y > y) ? NORTH : SOUTH) // Get the dir based on coordinates.
		i            = LIGHTING_CORNER_DIAGONAL.Find(turn(masters[T], 180))
		T.corners[i] = src

// God that was a mess, now to do the rest of the corner code! Hooray!
/datum/lighting_corner/proc/update_lumcount(var/delta_r, var/delta_g, var/delta_b)
	// world << "updating lumcount: [delta_r], [delta_g], [delta_b]"
	lum_r += delta_r
	lum_g += delta_g
	lum_b += delta_b

	for(var/TT in masters)
		var/turf/T = TT
		if(T.lighting_overlay)
			if(!T.lighting_overlay.needs_update)
				T.lighting_overlay.needs_update = TRUE
				lighting_update_overlays += T.lighting_overlay

/proc/initialize_lighting_corners()
	for(var/turf/T in turfs)
		for(var/i = 1 to 4)
			if(T.corners[i]) // Already have a corner on this direction.
				continue

			T.corners[i] = new/datum/lighting_corner(T, LIGHTING_CORNER_DIAGONAL[i])

/world/New()
	. = ..()
	initialize_lighting_corners()
