note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_PLACE_EXIT

inherit

	EQA_TEST_SET

feature

	test_make_place_exit
		note
			testing: "covers/{PLACE_EXIT}.make"
		local
			exit: PLACE_EXIT
		do
			create exit.make ("north", "test_area-test_place", 50, "some description")
			assert ("good_direction", equal (exit.direction.to_string, "north"))
			assert ("good_destination_place_slug", equal (exit.destination_place_slug.to_string, "test_area-test_place"))
			assert ("good_dificulty_level", exit.difficulty_level.to_integer = 50)
			assert ("good_description", equal (exit.description.to_string, "some description"))
		end

end
