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
			testing: "covers/{WORLD_STORAGE}.store_place", "covers/{WORLD_STORAGE}.retrieve_object_by_slug", "covers/{WORLD_STORAGE}.retrieved_object"
		local
			storage: WORLD_STORAGE
		do
			storage.retrieve_object_by_slug({STORABLE_TYPE}.Place, "poblado-calle01") -- This time should create the object from definition
			if storage.error_occurred then
				assert ("create error, message: " + storage.last_error_message, False)
			else
    			if attached {PLACE} storage.retrieved_object as place then
    				assert ("correctly retrieved", equal (place.slug.to_string, "poblado-calle01"))

        			storage.store_object ({STORABLE_TYPE}.Place, place)

        			storage.retrieve_object_by_slug ({STORABLE_TYPE}.Place, place.slug) -- This time should retrieve the object from storage
        			if storage.error_occurred then
        				assert ("retrieve error, message: " + storage.last_error_message, False)
        			else
            			if attached {PLACE} storage.retrieved_object as other_place then
            				assert ("correctly retrieved", equal (place.slug.to_string, other_place.slug.to_string))
            			else
            			    assert ("object retrieved is not a place", False)
            			end
            		end
            	else
    			    assert ("object retrieved is not a place", False)
    			end
			end
		end

	test_retrieve_unexistent_slug
		note
			testing: "covers/{WORLD_STORAGE}.retrieve_object_by_slug", "covers/{WORLD_STORAGE}.retrieved_object"
		local
			storage: WORLD_STORAGE
		do
			create storage
			storage.retrieve_object_by_slug ({STORABLE_TYPE}.Place, "dummy_area-dummy_place")
			if not storage.error_occurred then
				assert ("This should not occur, the slug does not exist", False)
			end
		end

end
