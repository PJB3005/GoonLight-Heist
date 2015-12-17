/obj/lamp
	name        = "lamp"

	icon        = 'ExampleProject/obj.dmi'
	icon_state  = "lamp-on"

	light_range = 3
	light_color = "#FFFF00"

	var/on      = 0

/obj/lamp/verb/change_color(var/new_color as color)
	set_light(l_color = new_color)

/obj/lamp/verb/change_range(var/new_range as num)
	set_light(new_range)

	if(new_range)
		icon_state = "lamp-off"

/obj/lamp/verb/delete()
	del(src)
