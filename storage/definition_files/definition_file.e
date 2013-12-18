note
	description: "A file that describes instances of some WORLD_STORABLE type. In the current implementation, it's an XML file."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DEFINITION_FILE

feature -- Access

	create_object_from_def (slug: NON_EMPTY_STRING)
			-- Locate the file that describes the object identified by the slug, and instantiates
			-- it from the description in the file.
			-- If the file does not exist (or is unreadable), return Void and sets an error message.
		deferred
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

feature {DEFINITION_FILE} -- XML parsing

    read_xml_file (slug: NON_EMPTY_STRING)
    		-- Locate the xml that describes the object identified by the slug, read it and
    		-- create an xml_document in memory.
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

			create file.make_with_name (file_name_for_slug (slug))
			if file.exists and then file.is_readable then
				file.open_read
				parser.parse_from_file (file)
				file.close
	    		if not parser.error_occurred and then (attached tree.document as xml_structure) then
	    			xml_document := xml_structure
		    	end
		    end
        end

	xml_root_element: detachable XML_ELEMENT
			-- The root element of the document read by read_xml_file
		require
		    status_ok: not error_occurred
		do
			if attached xml_document as doc then
			    Result := doc.root_element
			else
			    Result := Void
			end
		end

feature {NONE} -- Configuration constants

	Definition_file_dir: STRING = "data/world_definition/"

feature {DEFINITION_FILE} -- Configuration redefined in subclasses

	Definition_file_subdir: STRING
		deferred
		end

feature {NONE} -- Implementation

	xml_document: detachable XML_DOCUMENT

	file_name_for_slug (slug: NON_EMPTY_STRING): STRING
		local
		    pieces: LIST [STRING]
		do
			pieces := slug.to_string.split('-')
			if not pieces.is_empty then
			    Result := Definition_file_dir + Definition_file_subdir + pieces[1] + "/" + slug.to_string + ".xml"
			else
			    Result := "<bad formed slug>"
			end
		end

end
