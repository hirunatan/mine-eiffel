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
            -- Maximum number of generated objects that can exist in the place (0 = no limit)

	difficulty_level: MAGNITUDE_INT_100
			-- How difficult is to perceive this object (0 = automatic; 100 = impossible)

    quantity: MAGNITUDE_INT_POSITIVE
            -- The initial number of generated objects that exist in the place

	description: NON_EMPTY_STRING
			-- The descriptive text of this object as seen by characters when look at the place

	instances: LIST [OBJECT]
			-- One or more actual instances of the object. There always be at least one instance,
			-- unles probability > 0, in which case it's allowed to have empty instances since
			-- they can be generated next time a character enters the place.

feature -- Initialization

	make (the_object_slug: NON_EMPTY_STRING; the_probability: MAGNITUDE_INT_100; the_maximum: MAGNITUDE_INT_POSITIVE;
          the_difficulty_level: MAGNITUDE_INT_100; the_quantity: MAGNITUDE_INT_POSITIVE; the_description: NON_EMPTY_STRING)
   		local
   			i: INTEGER
		do
            object_slug := the_object_slug
            probability := the_probability
            maximum := the_maximum
            difficulty_level := the_difficulty_level
            quantity := the_quantity
            description := the_description
			create {ARRAYED_LIST [OBJECT]} instances.make (0)
			from i := 0 until i >= quantity loop
				object_appears
				i := i + 1
			end
		ensure
			initial_instances: instances.count = quantity
        end

feature -- Events

	character_entered
			-- When any character enters he place, objects may appear or disappear
	do
		if probability > 0 then
			dices.roll_1d100
        	if dices.roll_result <= probability.to_integer then
        		dices.roll_1d100
        		if dices.roll_result > 50 then
        			if instances.count < maximum then
        				object_appears
        			end
        		else
        			if instances.count > 0 then
        				object_disappears
        			end
        		end
        	end
		end
	ensure
		objects_appearing: instances.count = old instances.count + 1 or
		                   instances.count = old instances.count - 1 or
		                   instances.count = old instances.count
	end

feature {NONE} -- Implementation

	dices: DICES

	object_appears
		local
			registry: DEFINITION_FILE_REGISTRY
			definition_file: DEFINITION_FILE
		do
			definition_file := registry.get_definition_file_for ({STORABLE_TYPE}.object, object_slug)
			if not definition_file.error_occurred then
				if attached {OBJECT} definition_file.created_object as created_object then
					instances.extend (created_object)
				end
			end
		ensure
			one_more_object: instances.count = old instances.count + 1
		end

	object_disappears
		do
			instances.prune (instances[1])
		ensure
			one_less_object: instances.count = old instances.count - 1
		end

invariant
	instances_not_full: maximum.to_integer = 0 or instances.count <= maximum
	existing_instances: instances.count > 0 or probability.to_integer > 0

end
