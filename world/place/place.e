	note
	description: "A room or other type of location inside the game"
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Unnamed", "protocol=URI", "src=http://www.yourwebsite.com"

class
	PLACE

inherit
    WORLD_STORABLE
		redefine
    		slug
 		end

create
	make

feature -- Attributes

	slug: NON_EMPTY_STRING
			-- Unique identifier for a place (in the form "area_name-place_name").

	author: NON_EMPTY_STRING
			-- Name of the author of this place

	area_name: NON_EMPTY_STRING
			-- Name of the area which this place belongs to

	place_name: NON_EMPTY_STRING
			-- The name of this place in the game

	aura: MAGNITUDE_INT_100
			-- Aura level of this place (<50 = evil, 50 = neutral, >50 = good)

	place_type: NON_EMPTY_STRING
			-- Tye type of place

	place_subtype: NON_EMPTY_STRING
			-- The subtype of place

	capacity: MAGNITUDE_REAL_POSITIVE
			-- The capacity of the place (1 unit = the size of a human)

	light: MAGNITUDE_INT_100
			-- The illumination level in this place (0 = Morgoth's darkness; 100 = in front of Eru)

	hiding_value: MAGNITUDE_INT_100
			-- The ease of hiding in this place (0 = impossible; 100 = sure)

	description: ARRAY [PLACE_DESCRIPTION_ITEM]
			-- The visible description of the place (composed of items, some of that which not be visible for a character)

	exits: ARRAY [PLACE_EXIT]
			-- The possible exits from this place to other ones

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			slug := "x"
			author := "x"
			area_name := "x"
			place_name := "x"
			aura := 4
			place_type := "x"
			place_subtype := "x"
			capacity := 1
			light := 50
			hiding_value := 50
			description := <<>>
			exits := <<>>
		end

feature {NONE} -- Implementation

end
