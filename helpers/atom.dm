// Gets the turf under an atom (or the src if it IS a turf).
// Technically I'm unsure of the license since Lummox Jr. wrote it.
/proc/get_turf(var/const/atom/O)
	if(isnull(O) || isarea(O) || !istype(O))
		return

	var/atom/A
	for(A=O, A && !isturf(A), A=A.loc);  // semicolon is for the empty statement
	. = A
