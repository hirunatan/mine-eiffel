note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_OBJECT_DESCRIPTION

inherit

	EQA_TEST_SET

feature -- Test routines

	test_make_description
		note
			testing: "covers/{OBJECT_DESCRIPTION}.make"
		local
			object_description: OBJECT_DESCRIPTION
		do
			create object_description.make
		end

	test_add_remove_item
		note
			testing: "covers/{OBJECT_DESCRIPTION}.extend", "covers/{OBJECT_DESCRIPTION}.prune", "covers/{OBJECT_DESCRIPTION}.new_cursor"
		local
			object_description: OBJECT_DESCRIPTION
			count: INTEGER
		do
			create object_description.make
			object_description.extend (create {OBJECT_DESCRIPTION_ITEM}.make(0, "test description"))
			across object_description as pdc loop count := count + 1 end
			assert("iteration correct", count = 1)
			object_description.prune (object_description[1])
		end

	test_visible_items
		note
			testing: "covers/{OBJECT_DESCRIPTION}.visible_items"
		local
			object_description: OBJECT_DESCRIPTION
			visible_items: LIST [OBJECT_DESCRIPTION_ITEM]
		do
			create object_description.make
			object_description.extend (create {OBJECT_DESCRIPTION_ITEM}.make(10, "visible object description"))
			object_description.extend (create {OBJECT_DESCRIPTION_ITEM}.make(40, "invisible object description"))
			visible_items := object_description.visible_items (20)
		end

end
