note
	description: "The list of description items in a place"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLACE_DESCRIPTION

inherit
	ITERABLE [PLACE_DESCRIPTION_ITEM]

create {DEFINITION_BLOCK_PLACE_DESCRIPTION, TEST_PLACE, TEST_PLACE_DESCRIPTION}
	make

feature -- Access

	count: INTEGER
			-- The number of items in this description
		do
			Result := description_items.count
		end

	i_th alias "[]" (i: INTEGER): PLACE_DESCRIPTION_ITEM
			-- Item at `i'-th position
		require
			valid_index: valid_index (i)
		do
			Result := description_items[i]
		end

	valid_index (i: INTEGER): BOOLEAN
			-- Is i within allowable bounds?
		do
			Result := description_items.valid_index (i)
		ensure
			valid_index_definition: Result = ((i >= 1) and (i <= count))
		end

	has (description_item: PLACE_DESCRIPTION_ITEM): BOOLEAN
			-- Check if this description contains this item
		do
			Result := description_items.has (description_item)
		end

	new_cursor: INDEXABLE_ITERATION_CURSOR [PLACE_DESCRIPTION_ITEM]
			-- Return a cursor suitable for "across" loops
		do
			Result := description_items.new_cursor
		end

feature -- Modification

	extend (description_item: PLACE_DESCRIPTION_ITEM)
			-- Add the item at the end of this description
		do
			description_items.extend (description_item)
		ensure
			item_added: count = old count + 1
			item_exists: Current.has (description_item) = True
		end

	prune (description_item: PLACE_DESCRIPTION_ITEM)
			-- Remove all occurences of item from the description, if exists (if not, does nothing)
		do
			description_items.prune_all (description_item)
		ensure
			item_removed_if_exists: old Current.has (description_item) = True implies count = old count - 1
			item_not_removed_if_not_exists: old Current.has (description_item) = False implies count = old count
			item_not_exists: Current.has (description_item) = False
		end

feature -- World logic

	visible_items (perception_roll: MAGNITUDE_INT_100): LIST [PLACE_DESCRIPTION_ITEM]
			-- The items that a character can see given one perception roll
		do
			create {ARRAYED_LIST [PLACE_DESCRIPTION_ITEM]} Result.make (0)
			across description_items as dic loop
				if perception_roll.to_integer > dic.item.difficulty_level then
					Result.extend (dic.item)
				end
			end
		ensure
			all_pass_visible: across Current as cc all cc.item.difficulty_level.to_integer < perception_roll.to_integer implies Result.has(cc.item) end
			all_dont_pass_not_visible: across Current as cc all cc.item.difficulty_level.to_integer >= perception_roll.to_integer implies not Result.has(cc.item) end
		end

feature {NONE} -- Constructor

	make
		do
			create {ARRAYED_LIST [PLACE_DESCRIPTION_ITEM]} description_items.make (0)
		ensure
			empty_list: count = 0
		end

feature {NONE} -- Implementation

	description_items: LIST [PLACE_DESCRIPTION_ITEM]

end
