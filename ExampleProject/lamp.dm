/obj/lamp
	name        = "lamp"

	icon        = 'ExampleProject/obj.dmi'
	icon_state  = "lamp-on"

	light_range = 5
	// light_color = "#FFFF00"

/obj/lamp/verb/change_color(var/new_color as color)
	set src in view()
	set_light(l_color = new_color)

/obj/lamp/verb/change_range(var/new_range as num)
	set src in view()
	set_light(new_range)

	if(new_range)
		icon_state = "lamp-off"

/obj/lamp/verb/delete()
	set src in view()
	qdel(src)
