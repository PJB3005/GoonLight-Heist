# Contribution rules for the repo.

## Absolute pathing:
Absolute pathing is required, except, in the case of variables, one level after the base typepath.

Example:

This:
``` DM
/obj/my_obj
	var/health = 100
	var/defense
	var/mob/holder

/obj/my_obj/New(var/atom/loc, var/n_health = 0, var/n_defense = 0)
	. = ..()

	if(n_health)
		health  = n_health

	... // More code.
```

Instead of this:
``` DM
/obj/my_obj
	var
		health = 100
		defense
		mob
			holder

	New(var/atom/loc, var/n_health = 0, var/n_defense = 0)
		. = ..()

		if(n_health)
			health  = n_health

		... // More code.
```
