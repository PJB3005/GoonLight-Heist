/mob
	see_invisible = 100

/world/view = 10

/mob/verb/spawn_lamp()
	new/obj/lamp(loc)

/mob/verb/spawn_door()
	new/obj/door(loc)

/mob/verb/change_turf_type(var/new_type as text)
	var/turf/T = loc
	T.change_turf(new_type) 
