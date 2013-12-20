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

	slug: NON_EMPTY_STRING

	create_object_from_definition
			-- Locate the file that describes the object identified by the slug, and instantiates
			-- it from the description in the file.
			-- If the file does not exist (or is unreadable), and sets an error message.
		local
			exception_raised: BOOLEAN
		do
			if not exception_raised then
				created_object := Void
				create_object_from_file
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

	instantiate_object (xml_definition: XML_DEFINITION)
			-- Use the information of the root element parsed and the xml helper methods to instantiate
			-- the created object. Raise a developer exception using error if the file info is incorrect.
		require
			xml_definition_ok: not xml_definition.error_occurred
		deferred
		ensure
			object_correctly_created: created_object /= Void
		end

feature {NONE} -- Configuration constants

	Definition_file_dir: STRING = "data/world_definition/"

feature {DEFINITION_FILE} -- Configuration redefined in subclasses

	Definition_file_subdir: STRING
		deferred
		end

feature {NONE} -- Implementation

	create_object_from_file
		local
			file: PLAIN_TEXT_FILE
			xml_definition: XML_DEFINITION
		do
			create file.make_with_name (file_name_for_slug)
			if file.exists and then file.is_readable then
				file.open_read
				create xml_definition.make_from_file (file)
				file.close
				if not xml_definition.error_occurred then
					instantiate_object(xml_definition)
					last_error_message := ""
				else
					raise ("Error reading definition for '" + slug.to_string + "': " + xml_definition.last_error_message)
				end
			else
				raise ("Cannot find definition for '" + slug.to_string + "'")
			end
		end

	file_name_for_slug: STRING
		local
			pieces: LIST [STRING]
		do
			pieces := slug.to_string.split('-')
			if pieces.count > 1 then
				Result := Definition_file_dir + Definition_file_subdir + pieces[1] + "/" + slug.to_string + ".xml"
			else
				Result := Definition_file_dir + Definition_file_subdir + slug.to_string + ".xml"
			end
		end

invariant
	no_object_if_error: error_occurred implies created_object = Void
	object_if_not_error: (not error_occurred) implies created_object /= Void

end
