note
	description: "One possible exit from a place"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLACE_EXIT

create
	make

feature -- Attributes

	direction: NON_EMPTY_STRING
			-- the cardinal point of the exit direction ("norte", "sur", "arriba"...)

	destination_place_slug: NON_EMPTY_STRING
			-- Identifier of the place this exit leads to

	difficulty_level: MAGNITUDE_INT_100
			-- How difficult is to perceive this exit (0 = automatic; 100 = impossible)

	description: NON_EMPTY_STRING
			-- The descriptive text of this exit

feature {NONE} -- Initialization

	make (dir: NON_EMPTY_STRING; dest: NON_EMPTY_STRING; diff: MAGNITUDE_INT_100; desc: NON_EMPTY_STRING)
		do
			direction := dir
			destination_place_slug := dest
			difficulty_level := diff
			description := desc
		end

end
