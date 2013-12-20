note
	description: "The list of exits in a place"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLACE_EXITS

inherit
	ITERABLE [PLACE_EXIT]

create {DEFINITION_BLOCK_PLACE_EXITS, TEST_PLACE, TEST_PLACE_EXITS}
	make

feature -- Access

	count: INTEGER
			-- The number of exits in this list
		do
			Result := exits.count
		end

	i_th alias "[]" (i: INTEGER): PLACE_EXIT
			-- Item at `i'-th position
		require
			valid_index: valid_index (i)
		do
			Result := exits[i]
		end

	valid_index (i: INTEGER): BOOLEAN
			-- Is i within allowable bounds?
		do
			Result := exits.valid_index (i)
		ensure
			valid_index_definition: Result = ((i >= 1) and (i <= count))
		end

	has (exit: PLACE_EXIT): BOOLEAN
			-- Check if this list contains this exit
		do
			Result := exits.has (exit)
		end

	new_cursor: INDEXABLE_ITERATION_CURSOR [PLACE_EXIT]
			-- Return a cursor suitable for "across" loops
		do
			Result := exits.new_cursor
		end

feature -- Modification

	extend (exit: PLACE_EXIT)
			-- Add the exit at the end of this list
		do
			exits.extend (exit)
		ensure
			exit_added: count = old count + 1
			exit_exists: Current.has (exit) = True
		end

	prune (exit: PLACE_EXIT)
			-- Remove all occurences of exit from the list, if exists (if not, does nothing)
		do
			exits.prune_all (exit)
		ensure
			exit_removed_if_exists: old Current.has (exit) = True implies count = old count - 1
			exit_not_removed_if_not_exists: old Current.has (exit) = False implies count = old count
			exit_not_exists: Current.has (exit) = False
		end

feature -- World logic

	visible_exits (perception_roll: MAGNITUDE_INT_100): LIST [PLACE_EXIT]
			-- The exits that a character can see given one perception roll
		do
			create {ARRAYED_LIST [PLACE_EXIT]} Result.make (0)
			across exits as dic loop
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
			create {ARRAYED_LIST [PLACE_EXIT]} exits.make (0)
		ensure
			empty_list: count = 0
		end

feature {NONE} -- Implementation

	exits: LIST [PLACE_EXIT]

end
