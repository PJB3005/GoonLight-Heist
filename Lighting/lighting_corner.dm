// Because we can control each corner of every lighting overlay.
// And corners get shared between multiple turfs (unless you're on the corners of the map, then 1 corner doesn't).
// For the record: these should never ever ever be deleted, even if the turf doesn't have dynamic lighting.

// This list is what the code that assigns corners listens to, the order in this list is the order in which corners are added to the /turf/corners list.
/var/list/LIGHTING_CORNER_DIAGONAL = list(NORTHEAST, SOUTHEAST, SOUTHWEST, NORTHWEST)

/datum/lighting_corner
	var/list/turf/masters = list()
	// var/list/datum/light_source/affecting_lights = list()

	// Mostly here for simplicity.
	var/x     = 0
	var/y     = 0

	var/lum_r = 0
	var/lum_g = 0
	var/lum_b = 0

	#ifndef LIGHTING_INSTANT_UPDATES
	var/tmp/needs_update = FALSE
	#endif

/datum/lighting_corner/New(var/turf/new_turf, var/diagonal)
	. = ..()

	masters[new_turf] = diagonal

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
		masters[T]   = turn(diagonal, 180)
		i            = LIGHTING_CORNER_DIAGONAL.Find(diagonal)
		T.corners[i] = src

	// Now the one horizontal to
	T = get_step(new_turf, horizontal)
	if(T) // Ditto.
		masters[T]   = turn(horizontal, 180) | vertical
		i            = LIGHTING_CORNER_DIAGONAL.Find(masters[T])
		T.corners[i] = src

	// And finally the vertical one.
	T = get_step(new_turf, vertical)
	if(T)
		masters[T]   = turn(vertical, 180) | horizontal
		i            = LIGHTING_CORNER_DIAGONAL.Find(masters[T])
		T.corners[i] = src

// God that was a mess, now to do the rest of the corner code! Hooray!
/datum/lighting_corner/proc/update_lumcount(var/delta_r, var/delta_g, var/delta_b)
	// world << "updating lumcount: [delta_r], [delta_g], [delta_b]"
	lum_r += delta_r
	lum_g += delta_g
	lum_b += delta_b

#ifndef LIGHTING_INSTANT_UPDATES
	if(!needs_update)
		lighting_update_corners += src
		needs_update = TRUE

/datum/lighting_corner/proc/update_overlays()
#endif
	var/mx = max(lum_r, lum_g, lum_b) // Scale it so 1 is the strongest lum, if it is above 1.
	. = 1 // factor
	if(mx > 1)
		. = 1 / mx

	// world << "factor: [.]"

	for(var/turf/T in masters)
		if(!T.lighting_overlay)
			continue

		var/i = 0
		switch(masters[T])
			if(NORTHEAST)
				// world << "NORTHEAST"
				i = AR

			if(SOUTHEAST)
				// world << "SOUTHEAST"
				i = GR

			if(SOUTHWEST)
				// world << "SOUTHWEST"
				i = RR

			if(NORTHWEST)
				// world << "NORTHWEST"
				i = BR

		var/list/L = T.lighting_overlay.color:Copy() // For some dumb reason BYOND won't allow me to use [] on a colour matrix directly.

		L[i    ] = lum_r * .
		L[i + 1] = lum_g * .
		L[i + 2] = lum_b * .

		T.lighting_overlay.color = L

		// world << list2params(T.lighting_overlay.color)

/proc/initialize_lighting_corners()
	for(var/turf/T in turfs)
		for(var/i = 1 to 4)
			if(T.corners[i]) // Already have a corner on this direction.
				continue

			T.corners[i] = new/datum/lighting_corner(T, LIGHTING_CORNER_DIAGONAL[i])

/world/New()
	. = ..()
	initialize_lighting_corners()
