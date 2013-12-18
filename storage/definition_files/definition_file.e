note
	description: "A file that describes instances of some WORLD_STORABLE type. In the current implementation, it's an XML file."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DEFINITION_FILE

inherit
	EXCEPTIONS

feature -- Access

	create_object_from_def (the_slug: NON_EMPTY_STRING)
			-- Locate the file that describes the object identified by the slug, and instantiates
			-- it from the description in the file.
			-- If the file does not exist (or is unreadable), return Void and sets an error message.
		local
		    exception_raised: BOOLEAN
		do
		    if not exception_raised then
		        slug := the_slug
		    	created_object := Void
		    	read_xml_file (the_slug)
		        instantiate_object
		        last_error_message := ""
		    end
		rescue
			if is_developer_exception then
				-- If any developer exception, exit with the object not created and an error occurred
				if attached developer_exception_name as message then
				    last_error_message := message.as_string_32
				else
				    last_error_message := "Unknown exception"
				end
			    exception_raised := True
			    retry
			end
		end

	created_object: detachable WORLD_STORABLE
			-- The object if the last call to retrieve_object_by_slug was successful, or Void if not.

feature -- Status

	error_occurred: BOOLEAN
			-- True if the last call to create_object_from_def generated an error
			-- (or if it has not been called yet)
		do
			Result := not last_error_message.is_empty
		end

	last_error_message: STRING
			-- If error_occurred, here it is the message.
		attribute
			Result := "(still not called)"
		end

feature {DEFINITION_FILE} -- Subclass deferred and helper features

	slug: detachable NON_EMPTY_STRING

	instantiate_object
			-- Use the information of the root element parsed and the xml helper methods to instantiate
			-- the created object. Raise a developer exception using error if the file info is incorrect.
		require
		    document_correctly_read: xml_document /= Void
		deferred
		ensure
		    object_correctly_created: created_object /= Void
		end

    error (message: STRING)
    		-- Raise a developer exception with the given message
    	do
    	    raise (message)
    	end

	xml_document: detachable XML_DOCUMENT

	xml_root_element: detachable XML_ELEMENT
			-- The root element of the document read by read_xml_file (Void if not read).
		do
			if attached xml_document as doc then
			    Result := doc.root_element
			else
			    Result := Void
			end
		end

	non_empty_string_attribute (element: XML_ELEMENT; attribute_name: STRING): NON_EMPTY_STRING
			-- Get a non empty string attribute of the element, raise an exception if it does not exist or is not valid
		local
		    d_attr: detachable XML_ATTRIBUTE
		do
		    d_attr := element.attribute_by_name (attribute_name)
		    if attached d_attr as attr and then not attr.value.is_empty then
		    	create Result.make_from_string(attr.value.as_string_32)
		    else
				error("Cannot find attribute '" + attribute_name + "' of element '" + element.name + "'")
				Result := "xx"  -- Required by void safety, this will never execute
		    end
		end

	magnitude_int_100_attribute (element: XML_ELEMENT; attribute_name: STRING; default_value: detachable MAGNITUDE_INT_100): MAGNITUDE_INT_100
			-- Get a magnitude int 100 attribute of the element. If not exists and default_value is not void, return it;
			-- If it is void or the attribute is not valid, raise an exception.
		local
		    d_attr: detachable XML_ATTRIBUTE
		    attr_value: INTEGER
		do
			Result := 0
		    d_attr := element.attribute_by_name (attribute_name)
		    if attached d_attr as attr and then not attr.value.is_empty then
		    	if attr.value.is_integer then
		    	    attr_value := attr.value.to_integer
		    	    if attr_value >= 0 and attr_value <= 100 then
		    	        Result := attr_value
		    	    else
		    	        error("Attribute '" + attribute_name + "' of element '" + element.name + "' must be a number from 0 to 100")
		    	    end
		    	else
		    	    error("Attribute '" + attribute_name + "' of element '" + element.name + "' must be a number")
		    	end
		    else
		    	if attached default_value then
		    	    Result := default_value
		    	else
					error("Cannot find attribute '" + attribute_name + "' of element '" + element.name + "'")
		    	end
		    end
		end

	magnitude_real_positive_attribute (element: XML_ELEMENT; attribute_name: STRING; default_value: detachable MAGNITUDE_REAL_POSITIVE): MAGNITUDE_REAL_POSITIVE
			-- Get a magnitude real positive attribute of the element. If not exists and default_value is not void, return it;
			-- If it is void or the attribute is not valid, raise an exception.
		local
		    d_attr: detachable XML_ATTRIBUTE
		    attr_value: REAL
		do
			create Result.make_from_real (0.0)
		    d_attr := element.attribute_by_name (attribute_name)
		    if attached d_attr as attr and then not attr.value.is_empty then
		    	if attr.value.is_real then
		    	    attr_value := attr.value.to_real
		    	    if attr_value >= 0 then
		    	        Result := attr_value
		    	    else
		    	        error("Attribute '" + attribute_name + "' of element '" + element.name + "' must be a decimal number greater than 0")
		    	    end
		    	else
		    	    error("Attribute '" + attribute_name + "' of element '" + element.name + "' must be a decimal number")
		    	end
		    else
		    	if attached default_value then
		    	    Result := default_value
		    	else
					error("Cannot find attribute '" + attribute_name + "' of element '" + element.name + "'")
		    	end
		    end
		end

	non_empty_content (element: XML_ELEMENT): NON_EMPTY_STRING
			-- Get the content text of the element, raise an exception if it does not contain any text
		local
		    d_content: detachable STRING
		    content_prune: STRING
		do
			if attached element.text as text then
				d_content := text.as_string_32
			end
		    if attached d_content as content and then not content.is_empty then
		    	from
    		    	content_prune := ""
    		    	content_prune.copy (content)
		    	until
		    		not content_prune.ends_with(" ") and not content_prune.ends_with("%N")
		    	loop
		    		content_prune.prune_all_trailing ('%N')
		    		content_prune.prune_all_trailing (' ')
		    	end
		    	Result := content_prune
		    else
				error("Cannot find content of element '" + element.name + "'")
				Result := "xx"  -- Required by void safety, this will never execute
		    end
		end

	required_sub_element (element: XML_ELEMENT; element_name: STRING): XML_ELEMENT
			-- Get a subelement of the given element, raise an exception if it does not exist
		local
		    d_subelement: detachable XML_ELEMENT
		do
		    d_subelement := element.element_by_name (element_name)
		    if attached d_subelement as subelement then
		    	Result := subelement
		    else
				error("Cannot find sub element '" + element_name + "' of element '" + element.name + "'")
				Result := element  -- Required by void safety, this will never execute
		    end
		end

feature {NONE} -- Configuration constants

	Definition_file_dir: STRING = "data/world_definition/"

feature {DEFINITION_FILE} -- Configuration redefined in subclasses

	Definition_file_subdir: STRING
		deferred
		end

feature {NONE} -- Implementation

	file_name_for_slug (the_slug: NON_EMPTY_STRING): STRING
		local
		    pieces: LIST [STRING]
		do
			pieces := the_slug.to_string.split('-')
			if not pieces.is_empty then
			    Result := Definition_file_dir + Definition_file_subdir + pieces[1] + "/" + the_slug.to_string + ".xml"
			else
			    error ("Bad formed slug: '" + the_slug.to_string + "'")
			    Result := "xx"  -- Required by void safety, this will never execute
			end
		end

    read_xml_file (the_slug: NON_EMPTY_STRING)
    		-- Locate the xml that describes the object identified by the slug, read it and
    		-- create an xml_document in memory. Raises an exception if the file does not exist
    		-- or is not valid xml.
		local
			parser: XML_STOPPABLE_PARSER
			file: PLAIN_TEXT_FILE
			tree: XML_CALLBACKS_DOCUMENT
			resolver: XML_NAMESPACE_RESOLVER
        do
			create parser.make
			create tree.make_null
			create resolver.set_next (tree)
			parser.set_callbacks (resolver)

			create file.make_with_name (file_name_for_slug(the_slug))
			if file.exists and then file.is_readable then
				file.open_read
				parser.parse_from_file (file)
				file.close
	    		if not parser.error_occurred and then (attached tree.document as xml_structure) then
	    			xml_document := xml_structure
    		    else
    		    	if attached parser.error_message as msg then
    		    	    error ("Error reading definition for '" + the_slug.to_string + "': " + msg)
    		    	else
    		    	    error ("Error reading definition for '" + the_slug.to_string + "'")
    		    	end
		    	end
		    else
		        error ("Cannot find definition for '" + the_slug.to_string + "'")
		    end
		ensure
		    xml_document_read: xml_document /= Void
        end

end
