#define LIGHTING_HEIGHT 1
#define CLAMP01(x) (x >= 1 ? 1 : x <= 0 ? 0 : x)

/proc/falloff(var/rel_x, var/rel_y, var/size)
	. = rel_x ** 2 + rel_y ** 2 + LIGHTING_HEIGHT

	. = CLAMP01((1 - CLAMP01(sqrt(.) / size)) * (1 / (sqrt(. + 1))))

/client/verb/gen_icons(var/size as num)
	var/icon/I = icon()

	var/icon_size = (size * 2) + 1
	I.scale(icon_size, icon_size)

	

/client/verb/testclamp(var/num as num)
	world << num
	world << CLAMP01(num)
