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

	-- TODO: this method should be in other place
	normalized_name: STRING
			-- If the object_name contains [], the normalized name is what there is inside them
			-- (for example, "a simple [bucket]". If not, the normalized name is the first word
			-- that is not an article.
		local
			name_string: STRING
			start_pos, end_pos: INTEGER
			pieces: LIST [STRING]
			name_found: STRING
			articles: ARRAY [STRING]
		do
			articles :=
				<<"el", "la", "los", "las", "un", "uno", "una", "unos", "unas", "que",
				  "El", "La", "Los", "Las", "Un", "Uno", "Una", "Unos", "Unas", "Que">>

			name_string := object_name.to_string
			start_pos := name_string.index_of('[', 1)
			end_pos := name_string.index_of(']', 1)
			if start_pos > 0 and end_pos > 0 and (start_pos < end_pos) then
				name_found := name_string.substring(start_pos, end_pos)
			else
				pieces := object_name.to_string.split (' ')
				name_found := "not found"
				across pieces as pc loop
					if not across articles as ac some equal(ac.item, pc.item) end then
						if equal(name_found, "not found") then
							name_found := pc.item
						end
					end
				end
			end
			Result := name_found
		end

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
