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

	test_retrieve_unexistent_slug
		note
			testing: "covers/{DEFINITION_FILE}.retrieve_from_def"
		local
			registry: DEFINITION_FILE_REGISTRY
			definition_file: DEFINITION_FILE
		do
			definition_file := registry.get_definition_file_for({STORABLE_TYPE}.Place, "dummy_area-dummy_place")
			if not definition_file.error_occurred then
				assert ("This should not occur, the slug does not exist", False)
			end
		end

	test_retrieve_place_from_def
		note
			testing: "covers/{DEFINITION_FILE}.retrieve_from_def"
		local
			registry: DEFINITION_FILE_REGISTRY
			definition_file: DEFINITION_FILE
			exit: PLACE_EXIT
		do
			definition_file := registry.get_definition_file_for({STORABLE_TYPE}.Place, "poblado-calle01")
			if not definition_file.error_occurred then
    			if attached {PLACE} definition_file.created_object as created_place then
    			    assert ("correctly retrieved", equal (created_place.slug.to_string, "poblado-calle01"))
    			    assert ("correct author", equal (created_place.author.to_string, "Mandos"))
    			    assert ("correct area_name", equal (created_place.area_name.to_string, "poblado"))
    			    assert ("correct place_name", equal (created_place.place_name.to_string, "Final de la Calle del Sur"))
    			    assert ("correct aura", created_place.aura.to_integer = 50)
    			    assert ("correct place_type", equal (created_place.place_type.to_string, "Poblacion"))
    			    assert ("correct place_subtype", equal (created_place.place_subtype.to_string, "calle"))
    			    assert ("correct capacity", created_place.capacity.to_real = 40.0)
    			    assert ("correct light", created_place.light.to_integer = 60)
    			    assert ("correct hiding_value", created_place.hiding_value.to_integer = 10)
    			    assert ("correct description count", created_place.description.count = 3)
    			    across created_place.description as dc loop
    			        assert ("correct description_item difficulty", dc.item.difficulty_level.to_integer = 0)
    			    end
    			    assert ("correct exits count", created_place.exits.count = 4)
    			    across created_place.exits as ec loop
    			        assert ("correct exit difficulty", ec.item.difficulty_level.to_integer = 0)
    			    end
    			else
    			    assert ("object retrieved is not a place", False)
    			end
    		else
				assert ("retrieve error, message: " + definition_file.last_error_message, False)
			end
		end

	test_retrieve_object_from_def
		note
			testing: "covers/{DEFINITION_FILE}.retrieve_from_def"
		local
			registry: DEFINITION_FILE_REGISTRY
			definition_file: DEFINITION_FILE
			description_item: OBJECT_DESCRIPTION_ITEM
		do
			definition_file := registry.get_definition_file_for({STORABLE_TYPE}.Object, "cerveza01")
			if not definition_file.error_occurred then
    			if attached {OBJECT} definition_file.created_object as created_object then
    			    assert ("correctly retrieved", equal (created_object.slug.to_string, "cerveza01"))
    			    assert ("correct author", equal (created_object.author.to_string, "Mandos"))
    			    assert ("correct object_name", equal (created_object.object_name.to_string, "una jarra de [cerveza]"))
    			    assert ("correct object_type", equal (created_object.object_type.to_string, "cristal"))
    			    assert ("correct object_category", equal (created_object.object_category.to_string, "comestible"))
    			    assert ("correct weight", created_object.weight.to_real = 0.5)
    			    assert ("correct size", created_object.size.to_real = 0.1)
    			    assert ("correct price", created_object.price.to_real = 2)
    			    assert ("correct state", created_object.state.to_integer = 100)
    			    assert ("correct aura", created_object.aura.to_integer = 40)
    			    assert ("correct description count", created_object.description.count = 1)
    			    across created_object.description as dc loop
    			        assert ("correct description_item difficulty", dc.item.difficulty_level.to_integer = 0)
    			    end
    			else
    			    assert ("object retrieved is not an object", False)
    			end
    		else
				assert ("retrieve error, message: " + definition_file.last_error_message, False)
			end
		end

end
