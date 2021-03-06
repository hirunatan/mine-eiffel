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

create {DEFINITION_FILE_PLACE, TEST_PLACE}
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
			-- The type of place

	place_subtype: NON_EMPTY_STRING
			-- The subtype of place

	capacity: MAGNITUDE_REAL_POSITIVE
			-- The capacity of the place (1 unit = the size of a human)

	light: MAGNITUDE_INT_100
			-- The illumination level in this place (0 = Morgoth's darkness; 100 = in front of Eru)

	hiding_value: MAGNITUDE_INT_100
			-- The ease of hiding in this place (0 = impossible; 100 = sure)

	description: PLACE_DESCRIPTION
			-- The visible description of the place (composed of items, some of that which not be visible for a character)

	exits: PLACE_EXITS
			-- The possible exits from this place to other ones

	place_objects: PLACE_OBJECTS
			-- The objects in this place

	characters: INTEGER
			-- The number of characters inside the place

feature {NONE} -- Initialization

	make (the_slug: NON_EMPTY_STRING; the_author: NON_EMPTY_STRING; the_area_name: NON_EMPTY_STRING; the_place_name: NON_EMPTY_STRING;
		  the_aura: MAGNITUDE_INT_100; the_place_type: NON_EMPTY_STRING; the_place_subtype: NON_EMPTY_STRING;
		  the_capacity: MAGNITUDE_REAL_POSITIVE; the_light: MAGNITUDE_INT_100; the_hiding_value: MAGNITUDE_INT_100;
		  the_description: PLACE_DESCRIPTION; the_exits: PLACE_EXITS; the_place_objects: PLACE_OBJECTS)
		do
			slug := the_slug
			author := the_author
			area_name := the_area_name
			place_name := the_place_name
			aura := the_aura
			place_type := the_place_type
			place_subtype := the_place_subtype
			capacity := the_capacity
			light := the_light
			hiding_value := the_hiding_value
			description := the_description
			exits := the_exits
			place_objects := the_place_objects
		end

feature -- World logic

	enter_character
			-- Enter a character in the place
		do
			characters := characters + 1
			place_objects.character_entered
		ensure
			characters_incremented: characters = old characters + 1
		end

	exit_character
			-- Exit character from the place
		do
			characters := characters - 1
		ensure
			characters_decremented: characters = old characters - 1
		end

end
