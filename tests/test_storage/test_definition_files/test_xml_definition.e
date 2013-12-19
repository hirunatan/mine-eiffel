note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_XML_DEFINITION

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end

feature {NONE} -- Events

	file: PLAIN_TEXT_FILE

	on_prepare
		do
			create file.make_with_name ("data/world_definition/places/poblado/poblado-calle01.xml")
			if file.exists and then file.is_readable then
				file.open_read
			end
		end

	on_clean
		do
			if file.is_open_read then
			    file.close
			end
		end

feature -- Test routines

	test_xml_definition
		note
			testing:  "covers/{XML_DEFINITION}.make_from_file_name", "covers/{XML_DEFINITION_NODE}.make_from_element"
		local
		    xml_definition: XML_DEFINITION
		do
			create xml_definition.make_from_file (file)
			assert ("definition correct", not xml_definition.error_occurred)
			assert ("not empty root", not xml_definition.root_node.is_empty)
		end

	test_non_empty_string_attribute
		note
			testing:  "covers/{XML_DEFINITION_NODE}.non_empty_string_attribute"
		local
		    xml_definition: XML_DEFINITION
		    attr: NON_EMPTY_STRING
		do
			create xml_definition.make_from_file (file)
			assert ("definition correct", not xml_definition.error_occurred)
			assert ("not empty root", not xml_definition.root_node.is_empty)
			attr := xml_definition.root_node.non_empty_string_attribute ("area")
			assert ("attr correct", equal(attr.to_string, "poblado"))
		end

	test_non_empty_string_attribute_fail
		note
			testing:  "covers/{XML_DEFINITION_NODE}.non_empty_string_attribute"
		local
		    xml_definition: XML_DEFINITION
		    attr: NON_EMPTY_STRING
		    exception_raised: BOOLEAN
		do
			if not exception_raised then
				create xml_definition.make_from_file (file)
    			assert ("definition correct", not xml_definition.error_occurred)
    			assert ("not empty root", not xml_definition.root_node.is_empty)
    			attr := xml_definition.root_node.non_empty_string_attribute ("dummy_attribute")
    			assert ("exception raise", False)
			end
		rescue
		    exception_raised := True
		    retry
		end

	test_magnitude_int_100_attribute
		note
			testing:  "covers/{XML_DEFINITION_NODE}.magnitude_int_100_attribute"
		local
		    xml_definition: XML_DEFINITION
		    propiedades_node: XML_DEFINITION_NODE
		    attr: MAGNITUDE_INT_100
		do
			create xml_definition.make_from_file (file)
			assert ("definition correct", not xml_definition.error_occurred)
			assert ("not empty root", not xml_definition.root_node.is_empty)
			propiedades_node := xml_definition.root_node.required_sub_node ("propiedades")
			attr := propiedades_node.magnitude_int_100_attribute ("luz", 0)
			assert ("attr correct", attr.to_integer = 60)
		end

	test_magnitude_int_100_attribute_default
		note
			testing:  "covers/{XML_DEFINITION_NODE}.magnitude_int_100_attribute"
		local
		    xml_definition: XML_DEFINITION
		    propiedades_node: XML_DEFINITION_NODE
		    attr: MAGNITUDE_INT_100
		do
			create xml_definition.make_from_file (file)
			assert ("definition correct", not xml_definition.error_occurred)
			assert ("not empty root", not xml_definition.root_node.is_empty)
			propiedades_node := xml_definition.root_node.required_sub_node ("propiedades")
			attr := propiedades_node.magnitude_int_100_attribute ("dummy_attribute", 100)
			assert ("attr correct", attr.to_integer = 100)
		end

	test_magnitude_int_100_attribute_fail
		note
			testing:  "covers/{XML_DEFINITION_NODE}.magnitude_int_100_attribute"
		local
		    xml_definition: XML_DEFINITION
		    propiedades_node: XML_DEFINITION_NODE
		    attr: MAGNITUDE_INT_100
		    exception_raised: BOOLEAN
		do
			if not exception_raised then
				create xml_definition.make_from_file (file)
    			assert ("definition correct", not xml_definition.error_occurred)
    			assert ("not empty root", not xml_definition.root_node.is_empty)
    			propiedades_node := xml_definition.root_node.required_sub_node ("propiedades")
    			attr := propiedades_node.magnitude_int_100_attribute ("dummy_attribute", Void)
    			assert ("exception raise", False)
			end
		rescue
		    exception_raised := True
		    retry
		end

	test_magnitude_real_positive_attribute
		note
			testing:  "covers/{XML_DEFINITION_NODE}.magnitude_real_positive_attribute"
		local
		    xml_definition: XML_DEFINITION
		    propiedades_node: XML_DEFINITION_NODE
		    attr: MAGNITUDE_REAL_POSITIVE
		do
			create xml_definition.make_from_file (file)
			assert ("definition correct", not xml_definition.error_occurred)
			assert ("not empty root", not xml_definition.root_node.is_empty)
			propiedades_node := xml_definition.root_node.required_sub_node ("propiedades")
			attr := propiedades_node.magnitude_real_positive_attribute ("volumen", 0)
			assert ("attr correct", attr.to_real = 40.0)
		end

	test_magnitude_real_positive_attribute_default
		note
			testing:  "covers/{XML_DEFINITION_NODE}.magnitude_real_positive_attribute"
		local
		    xml_definition: XML_DEFINITION
		    propiedades_node: XML_DEFINITION_NODE
		    attr: MAGNITUDE_REAL_POSITIVE
		do
			create xml_definition.make_from_file (file)
			assert ("definition correct", not xml_definition.error_occurred)
			assert ("not empty root", not xml_definition.root_node.is_empty)
			propiedades_node := xml_definition.root_node.required_sub_node ("propiedades")
			attr := propiedades_node.magnitude_real_positive_attribute ("dummy_attribute", create {MAGNITUDE_REAL_POSITIVE}.make_from_real (200.5))
			assert ("attr correct", attr.to_real = 200.5)
		end

	test_magnitude_real_positive_attribute_fail
		note
			testing:  "covers/{XML_DEFINITION_NODE}.magnitude_real_positive_attribute"
		local
		    xml_definition: XML_DEFINITION
		    propiedades_node: XML_DEFINITION_NODE
		    attr: MAGNITUDE_REAL_POSITIVE
		    exception_raised: BOOLEAN
		do
			if not exception_raised then
				create xml_definition.make_from_file (file)
    			assert ("definition correct", not xml_definition.error_occurred)
    			assert ("not empty root", not xml_definition.root_node.is_empty)
    			propiedades_node := xml_definition.root_node.required_sub_node ("propiedades")
    			attr := propiedades_node.magnitude_real_positive_attribute ("dummy_attribute", Void)
    			assert ("exception raise", False)
			end
		rescue
		    exception_raised := True
		    retry
		end

	test_non_empty_content
		note
			testing:  "covers/{XML_DEFINITION_NODE}.non_empty_content"
		local
		    xml_definition: XML_DEFINITION
		    id_node: XML_DEFINITION_NODE
		    content: NON_EMPTY_STRING
		do
			create xml_definition.make_from_file (file)
			assert ("definition correct", not xml_definition.error_occurred)
			assert ("not empty root", not xml_definition.root_node.is_empty)
    		id_node := xml_definition.root_node.required_sub_node ("id")
			content := id_node.non_empty_content
			assert ("content correct", equal(content.to_string, "poblado-calle01"))
		end

	test_non_empty_content_fail
		note
			testing:  "covers/{XML_DEFINITION_NODE}.non_empty_content"
		local
		    xml_definition: XML_DEFINITION
		    content: NON_EMPTY_STRING
		    exception_raised: BOOLEAN
		do
			if not exception_raised then
				create xml_definition.make_from_file (file)
    			assert ("definition correct", not xml_definition.error_occurred)
    			assert ("not empty root", not xml_definition.root_node.is_empty)
    			content := xml_definition.root_node.non_empty_content
    			assert ("exception raise", False)
			end
		rescue
		    exception_raised := True
		    retry
		end

	test_required_sub_node
		note
			testing:  "covers/{XML_DEFINITION_NODE}.required_sub_node"
		local
		    xml_definition: XML_DEFINITION
		    nombre_node: XML_DEFINITION_NODE
		do
			create xml_definition.make_from_file (file)
			assert ("definition correct", not xml_definition.error_occurred)
			assert ("not empty root", not xml_definition.root_node.is_empty)
    		nombre_node := xml_definition.root_node.required_sub_node ("nombre")
		end

	test_required_sub_node_fail
		note
			testing:  "covers/{XML_DEFINITION_NODE}.required_sub_node"
		local
		    xml_definition: XML_DEFINITION
		    nombre_node: XML_DEFINITION_NODE
		    exception_raised: BOOLEAN
		do
			if not exception_raised then
				create xml_definition.make_from_file (file)
    			assert ("definition correct", not xml_definition.error_occurred)
    			assert ("not empty root", not xml_definition.root_node.is_empty)
	    		nombre_node := xml_definition.root_node.required_sub_node ("dummy_node")
    			assert ("exception raise", False)
			end
		rescue
		    exception_raised := True
		    retry
		end

end
