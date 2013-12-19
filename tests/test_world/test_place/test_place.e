note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_PLACE

inherit

	EQA_TEST_SET

feature

	test_make_place
		note
			testing: "covers/{PLACE}.make"
		local
			place: PLACE
		do
			create place.make (
				"test_area-test_place", "test author", "test_area", "The place of test", 50, "place type", "place subtype",
				create {MAGNITUDE_REAL_POSITIVE}.make_from_real(500.5), 40, 20,
				create {ARRAYED_LIST [PLACE_DESCRIPTION_ITEM]}.make (0), create {ARRAYED_LIST [PLACE_EXIT]}.make (0)
			)

			assert ("good_slug", equal (place.slug.to_string, "test_area-test_place"))
			assert ("good_author", equal (place.author.to_string, "test author"))
			assert ("good_area_name", equal (place.area_name.to_string, "test_area"))
			assert ("good_place_name", equal (place.place_name.to_string, "The place of test"))
			assert ("good_aura", place.aura.to_integer = 50)
			assert ("good_place_type", equal (place.place_type.to_string, "place type"))
			assert ("good_place_subtype", equal (place.place_subtype.to_string, "place subtype"))
			assert ("good_capacity", place.capacity.to_real = 500.5)
			assert ("good_light", place.light.to_integer = 40)
			assert ("good_hiding_value", place.hiding_value.to_integer = 20)
			assert ("good_description", place.description.count = 0)
			assert ("good_exits", place.exits.count = 0)
		end

end
