note
	description: "The list of objects in a place"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLACE_OBJECTS

inherit
	ITERABLE [PLACE_OBJECT]

create {DEFINITION_BLOCK_PLACE_OBJECTS, TEST_PLACE, TEST_PLACE_OBJECTS}
	make

feature -- Access

	count: INTEGER
			-- The number of objects in this list
		do
			Result := objects.count
		end

	i_th alias "[]" (i: INTEGER): PLACE_OBJECT
			-- The object at `i'-th position
		require
			valid_index: valid_index (i)
		do
			Result := objects[i]
		end

	valid_index (i: INTEGER): BOOLEAN
			-- Is i within allowable bounds?
		do
			Result := objects.valid_index (i)
		ensure
			valid_index_definition: Result = ((i >= 1) and (i <= count))
		end

	has (object: PLACE_OBJECT): BOOLEAN
			-- Check if this list contains this object
		do
			Result := objects.has (object)
		end

	new_cursor: INDEXABLE_ITERATION_CURSOR [PLACE_OBJECT]
			-- Return a cursor suitable for "across" loops
		do
			Result := objects.new_cursor
		end

feature -- Modification

	extend (object: PLACE_OBJECT)
			-- Add the object at the end of this list
		do
			objects.extend (object)
		ensure
			object_added: count = old count + 1
			object_exists: Current.has (object) = True
		end

	prune (object: PLACE_OBJECT)
			-- Remove all occurences of the object from the list, if exists (if not, does nothing)
		do
			objects.prune_all (object)
		ensure
			object_removed_if_exists: old Current.has (object) = True implies count = old count - 1
			object_not_removed_if_not_exists: old Current.has (object) = False implies count = old count
			object_not_exists: Current.has (object) = False
		end

feature -- World logic

	visible_objects (perception_roll: MAGNITUDE_INT_100): LIST [PLACE_OBJECT]
			-- The objects that a character can see given one perception roll
		do
			create {ARRAYED_LIST [PLACE_OBJECT]} Result.make (0)
			across objects as dic loop
				if perception_roll.to_integer > dic.item.difficulty_level then
					Result.extend (dic.item)
				end
			end
		ensure
			all_pass_visible: across Current as cc all cc.item.difficulty_level.to_integer < perception_roll.to_integer implies Result.has(cc.item) end
			all_dont_pass_not_visible: across Current as cc all cc.item.difficulty_level.to_integer >= perception_roll.to_integer implies not Result.has(cc.item) end
		end

	character_entered
			-- Event of that a character has entered in the place
		do
			across objects as oc loop
				oc.item.character_entered
			end
		end

	by_name (name: STRING): detachable OBJECT
			-- Get the first instance of the first object with this name in the place.
			-- Return Void if not found.
		local
			found: BOOLEAN
		do
			Result := Void
			across objects as oc loop
				if oc.item.instances.count > 0 then
					if equal(name, oc.item.instances[1].normalized_name) then
						if not found then
							Result := oc.item.instances[1]
							found := True
						end
					end
				end
			end
		end

	take (object: OBJECT)
			-- Remove the object from the place (if not exists, do nothing)
		local
			found: BOOLEAN
			place_object: PLACE_OBJECT
		do
			from objects.start until found or objects.after loop
				place_object := objects.item_for_iteration
				if equal(place_object.object_slug.to_string, object.slug.to_string) then
					found := True
					if place_object.instances.count > 1 or place_object.probability.to_integer > 0 then
						place_object.instances.prune(object)
					else
						objects.prune(place_object)
					end
				end
				objects.forth
			end
		end

feature {NONE} -- Constructor

	make
		do
			create {ARRAYED_LIST [PLACE_OBJECT]} objects.make (0)
		ensure
			empty_list: count = 0
		end

feature {NONE} -- Implementation

	objects: LIST [PLACE_OBJECT]

end
