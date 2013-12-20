note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_PLACE_EXITS

inherit

	EQA_TEST_SET

feature -- Test routines

	test_make_exits
		note
			testing: "covers/{PLACE_EXITS}.make"
		local
			place_exits: PLACE_EXITS
		do
			create place_exits.make
		end

	test_add_remove_exit
		note
			testing: "covers/{PLACE_EXITS}.extend", "covers/{PLACE_EXITS}.prune", "covers/{PLACE_EXITS}.new_cursor"
		local
			place_exits: PLACE_EXITS
			count: INTEGER
		do
			create place_exits.make
			place_exits.extend (create {PLACE_EXIT}.make("north", "test-place", 0, "test exit"))
			across place_exits as pdc loop count := count + 1 end
			assert("iteration correct", count = 1)
			place_exits.prune (place_exits[1])
		end

	test_visible_exits
		note
			testing: "covers/{PLACE_EXITS}.visible_exits"
		local
			place_exits: PLACE_EXITS
			visible_exits: LIST [PLACE_EXIT]
		do
			create place_exits.make
			place_exits.extend (create {PLACE_EXIT}.make("north", "test-place-1", 10, "visible test exit"))
			place_exits.extend (create {PLACE_EXIT}.make("south", "test-place-2", 40, "invisible test exits"))
			visible_exits := place_exits.visible_exits (20)
		end

end
