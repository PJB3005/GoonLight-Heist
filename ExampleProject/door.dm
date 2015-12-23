/obj/door
	name       = "door"

	icon       = 'ExampleProject/obj.dmi'
	icon_state = "door"

	opacity    = 1
	density    = 1

	var/open   = 0

/obj/door/Click(var/location, var/control, var/params)
	open       = !open

	density    = !open

	icon_state = open ? "door-o" : "door"

	set_opacity(!open)
