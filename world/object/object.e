note
	description: "Any physical object inside the game"
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Unnamed", "protocol=URI", "src=http://www.yourwebsite.com"

class
	OBJECT

inherit

	WORLD_STORABLE
		redefine
			slug
		end

create {DEFINITION_FILE_OBJECT, TEST_OBJECT}
	make

feature -- Attributes

	slug: NON_EMPTY_STRING
			-- Unique identifier for an object (any string).

	author: NON_EMPTY_STRING
			-- Name of the author of this object

	object_name: NON_EMPTY_STRING
			-- The name of this object in the game

	object_type: NON_EMPTY_STRING
			-- The material type of object

	object_category: NON_EMPTY_STRING
			-- The usage type of object

	weight: MAGNITUDE_REAL_POSITIVE
			-- The weight of the object in kilograms

	size: MAGNITUDE_REAL_POSITIVE
			-- The size of the object (1 unit = the size of a human)

	price: MAGNITUDE_REAL_POSITIVE
			-- The value of the object in tin coins

	state: MAGNITUDE_INT_100
			-- Health status of the object (100 = intact, 0 = completely broken)

	aura: MAGNITUDE_INT_100
			-- Aura level of this place (<50 = evil, 50 = neutral, >50 = good)

	description: LIST [OBJECT_DESCRIPTION_ITEM]
			-- The visible description of the objects (composed of items, some of that which not be visible for a character)

feature {NONE} -- Initialization

	make (the_slug: NON_EMPTY_STRING; the_author: NON_EMPTY_STRING; the_object_name: NON_EMPTY_STRING;
              the_object_type: NON_EMPTY_STRING; the_object_category: NON_EMPTY_STRING; the_weight: MAGNITUDE_REAL_POSITIVE;
              the_size: MAGNITUDE_REAL_POSITIVE; the_price: MAGNITUDE_REAL_POSITIVE; the_state: MAGNITUDE_INT_100;
              the_aura: MAGNITUDE_INT_100; the_description: LIST [OBJECT_DESCRIPTION_ITEM])
		do
            slug := the_slug
            author := the_author
            object_name := the_object_name
            object_type := the_object_type
            object_category := the_object_category
            weight := the_weight
            size := the_size
            price := the_price
            state := the_state
            aura := the_aura
            description := the_description
		end

end
