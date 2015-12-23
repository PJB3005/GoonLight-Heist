/obj/door
	name       = "door"

	icon       = 'ExampleProject/obj.dmi'
	icon_state = "door"

	opacity    = TRUE
	density    = TRUE

	var/open   = FALSE

/obj/door/Click(var/location, var/control, var/params)
	open       = !open

	density    = !open

	icon_state = open ? "door-o" : "door"

	set_opacity(!open)
