note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_OBJECT

inherit

	EQA_TEST_SET

feature

	test_make_object
		note
			testing: "covers/{OBJECT}.make"
		local
			object: OBJECT
		do
			create object.make (
				"test_object", "object author", "The name of the object", "object type", "object category",
				create {MAGNITUDE_REAL_POSITIVE}.make_from_real(333.33),
				create {MAGNITUDE_REAL_POSITIVE}.make_from_real(0.5),
				create {MAGNITUDE_REAL_POSITIVE}.make_from_real(3.5),
				100, 10,
				create {ARRAYED_LIST [OBJECT_DESCRIPTION_ITEM]}.make (0)
			)
			assert ("good_slug", equal (object.slug.to_string, "test_object"))
			assert ("good_author", equal (object.author.to_string, "object author"))
			assert ("good_object_name", equal (object.object_name.to_string, "The name of the object"))
			assert ("good_object_type", equal (object.object_type.to_string, "object type"))
			assert ("good_object_category", equal (object.object_category.to_string, "object category"))
			assert ("good_weight", object.weight.to_real = 333.33)
			assert ("good_size", object.size.to_real = 0.5)
			assert ("good_price", object.price.to_real = 3.5)
			assert ("good_state", object.state.to_integer = 100)
			assert ("good_aura", object.aura.to_integer = 10)
			assert ("good_description", object.description.count = 0)
		end

end
