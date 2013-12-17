note
	description: "A file that describes instances of some WORLD_STORABLE type. In the current implementation, it's an XML file."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DEFINITION_FILE

feature -- Access

	-- TODO: separate command / query
	create_object_from_def (slug: NON_EMPTY_STRING): detachable WORLD_STORABLE
			-- Locate the file that describes the object identified by the slug, and instantiates
			-- it from the description in the file.
			-- If the file does not exist (or is unreadable), return Void and sets an error message.
		deferred
		end

feature -- Status

	last_error_message: STRING
			-- If last call to create_object_from_def generated an error, here it is the message.
		attribute
			Result := ""
		end

feature {DEFINITION_FILE} -- XML parsing

    read_xml_file (slug: NON_EMPTY_STRING)
    		-- Locate the xml that describes the object identified by the slug, read it and
    		-- create an xml_document in memory.
		local
			parser: XML_STOPPABLE_PARSER
			l_file: PLAIN_TEXT_FILE
			l_tree: XML_CALLBACKS_DOCUMENT
			l_resolver: XML_NAMESPACE_RESOLVER
        do
			create parser.make
			create l_tree.make_null
			create l_resolver.set_next (l_tree)
			parser.set_callbacks (l_resolver)

			create l_file.make_with_name (file_name_for_slug (slug))
			if l_file.exists and then l_file.is_readable then
				l_file.open_read
				if l_file.is_open_read then
					parser.parse_from_file (l_file)
					l_file.close
		    		if not parser.error_occurred and then (attached l_tree.document as l_xml_structure) then
		    			xml_document := l_xml_structure
		    		end
		    	end
		    end
        end

	xml_root_element: detachable XML_ELEMENT
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
