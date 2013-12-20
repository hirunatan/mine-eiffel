note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_PLACE_DESCRIPTION

inherit

	EQA_TEST_SET

feature -- Test routines

	test_make_description
		note
			testing: "covers/{PLACE_DESCRIPTION}.make"
		local
			place_description: PLACE_DESCRIPTION
		do
			create place_description.make
		end

	test_add_remove_item
		note
			testing: "covers/{PLACE_DESCRIPTION}.extend", "covers/{PLACE_DESCRIPTION}.prune", "covers/{PLACE_DESCRIPTION}.new_cursor"
		local
			place_description: PLACE_DESCRIPTION
			count: INTEGER
		do
			create place_description.make
			place_description.extend (create {PLACE_DESCRIPTION_ITEM}.make(0, "test description"))
			across place_description as pdc loop count := count + 1 end
			assert("iteration correct", count = 1)
			place_description.prune (place_description[1])
		end

	test_visible_items
		note
			testing: "covers/{PLACE_DESCRIPTION}.visible_items"
		local
			place_description: PLACE_DESCRIPTION
			visible_items: LIST [PLACE_DESCRIPTION_ITEM]
		do
			create place_description.make
			place_description.extend (create {PLACE_DESCRIPTION_ITEM}.make(10, "visible place description"))
			place_description.extend (create {PLACE_DESCRIPTION_ITEM}.make(40, "invisible place description"))
			visible_items := place_description.visible_items (20)
		end

end
