note
	description: "One item of the description of a place."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLACE_DESCRIPTION_ITEM

create {DEFINITION_BLOCK_PLACE_DESCRIPTION, TEST_PLACE_DESCRIPTION, TEST_PLACE_DESCRIPTION_ITEM}
	make

feature -- Attributes

	difficulty_level: MAGNITUDE_INT_100
			-- How difficult is to perceive this item (0 = automatic; 100 = impossible)

	text: NON_EMPTY_STRING
			-- The descriptive text of this item

feature {NONE} -- Initialization

	make (d: MAGNITUDE_INT_100; t: NON_EMPTY_STRING)
		do
			difficulty_level := d
			text := t
		end

end
