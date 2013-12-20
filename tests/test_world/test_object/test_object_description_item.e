note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_OBJECT_DESCRIPTION_ITEM

inherit

	EQA_TEST_SET

feature -- Test routines

	test_make_description_item
		note
			testing: "covers/{OBJECT_DESCRIPTION_ITEM}.make"
		local
			item: OBJECT_DESCRIPTION_ITEM
		do
			create item.make (10, "some description")
			assert ("good_dificulty_level", item.difficulty_level.to_integer = 10)
			assert ("good_text", equal (item.text.to_string, "some description"))
		end

end
