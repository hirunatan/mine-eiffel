note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_PLACE_OBJECT

inherit

	EQA_TEST_SET

feature

	test_make_place_object
		note
			testing: "covers/{PLACE_OBJECT}.make"
		local
			place_object: PLACE_OBJECT
		do
			create place_object.make ("test_object", 50, 3, 0, 0, "some description")
			assert ("good_object_slug", equal (place_object.object_slug.to_string, "test_object"))
			assert ("good_probability", place_object.probability.to_integer = 50)
			assert ("good_maximum", place_object.maximum.to_integer = 3)
			assert ("good_dificulty_level", place_object.difficulty_level.to_integer = 0)
			assert ("good_quantity", place_object.quantity.to_integer = 0)
			assert ("good_description", equal (place_object.description.to_string, "some description"))
		end

end
