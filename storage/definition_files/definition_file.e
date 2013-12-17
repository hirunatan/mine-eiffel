note
	description: "A file that describes instances of some WORLD_STORABLE type. In the current implementation, it's an XML file."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DEFINITION_FILE

feature -- Access

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

end
