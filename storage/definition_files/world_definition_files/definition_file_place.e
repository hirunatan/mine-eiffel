note
	description: "Definition file for PLACE class"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFINITION_FILE_PLACE

inherit

	DEFINITION_FILE
		redefine
			create_object_from_def
		end

feature

	create_object_from_def (slug: NON_EMPTY_STRING): detachable PLACE
		do
			if slug.to_string.starts_with ("test") then
				create Result.make(slug)
			else
			    Result := Void
			    last_error_message := "Slug don't found"
			end
		end

end
