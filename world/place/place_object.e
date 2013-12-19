note
	description: "One object associated to place"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLACE_OBJECT

create
	make

feature -- Attributes

	object_slug: NON_EMPTY_STRING
			-- Identifier of the object to generate

	probability: MAGNITUDE_INT_100
			-- Probability (0 - 100%) of that a new object appears or disappears each time
            -- a character enters the place

    maximum: MAGNITUDE_INT_POSITIVE
            -- Maximum number of generated objects that can exist in the place

	difficulty_level: MAGNITUDE_INT_100
			-- How difficult is to perceive this object (0 = automatic; 100 = impossible)

    quantity: MAGNITUDE_INT_POSITIVE
            -- The initial number of generated objects that exist in the place

	description: NON_EMPTY_STRING
			-- The descriptive text of this object as seen by characters when look at the place

feature {NONE} -- Initialization

	make (the_object_slug: NON_EMPTY_STRING; the_probability: MAGNITUDE_INT_100; the_maximum: MAGNITUDE_INT_POSITIVE;
          the_difficulty_level: MAGNITUDE_INT_100; the_quantity: MAGNITUDE_INT_POSITIVE; the_description: NON_EMPTY_STRING)
		do
            object_slug := the_object_slug
            probability := the_probability
            maximum := the_maximum
            difficulty_level := the_difficulty_level
            quantity := the_quantity
            description := the_description
        end

end
