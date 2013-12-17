note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_WORLD_STORAGE

inherit

	EQA_TEST_SET

feature -- Test routines

	test_store_and_retrieve_place
		note
			testing: "covers/{WORLD_STORAGE}.store_place", "covers/{WORLD_STORAGE}.get_object_by_slug"
		local
			place: PLACE
			storage: WORLD_STORAGE
		do
			create place.make
			create storage.make
			storage.store_object (place)
			if attached {PLACE} storage.get_object_by_slug (place.slug) as retrieved_place then
				assert ("correctly retrieved", equal (place.slug.to_string, retrieved_place.slug.to_string))
			else
				assert ("retrieve error, message: " + storage.last_error_message, False)
			end
		end

	test_retrieve_unexistent_slug
		note
			testing: "covers/{WORLD_STORAGE}.get_object_by_slug"
		local
			storage: WORLD_STORAGE
		do
			create storage.make
			if attached {PLACE} storage.get_object_by_slug ("dummy_area-dummy_place") as retrieved_place then
				assert ("This should not occur, the slug does not exist", False)
			end
		end

end
