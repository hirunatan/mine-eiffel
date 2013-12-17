note
	description: "Summary description for {TEST_DEFINITION_FILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_DEFINITION_FILE

inherit

	EQA_TEST_SET

feature -- Test routines

	test_retrieve_place_from_def
		note
			testing: "covers/{DEFINITION_FILE}.retrieve_from_def"
		local
			registry: DEFINITION_FILE_REGISTRY
			definition_file: DEFINITION_FILE
		do
			definition_file := registry.get_definition_file_for("PLACE")
			if attached {PLACE} definition_file.create_object_from_def ("test_area-test_place") as retrieved_place then
			    assert ("correctly retrieved", equal (retrieved_place.slug.to_string, "test_area-test_place"))
			else
				assert ("retrieve error, message: " + definition_file.last_error_message, False)
			end
		end

	test_retrieve_unexistent_slug
		note
			testing: "covers/{DEFINITION_FILE}.retrieve_from_def"
		local
			registry: DEFINITION_FILE_REGISTRY
			definition_file: DEFINITION_FILE
		do
			definition_file := registry.get_definition_file_for("PLACE")
			if attached {PLACE} definition_file.create_object_from_def ("dummy_area-dummy_place") as retrieved_place then
				assert ("This should not occur, the slug does not exist", False)
			end
		end

end
