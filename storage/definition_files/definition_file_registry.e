note
	description: "A registry to get the definition file instance for some type inheriting from WORLD_STORABLE."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	DEFINITION_FILE_REGISTRY

feature -- Access to files

    get_definition_file_for(type: STRING): DEFINITION_FILE
    		-- An instance of DEFINITION_FILE able to create objects of the given type.
        do
        	Result := get_registry @ type
        end

feature {NONE} -- Implementation

	get_registry: TABLE [DEFINITION_FILE, STRING]
			-- The registry is a table that maps a type name inheriting from WORLD_STORABLE
			-- to an instance of DEFINITION_FILE. This hash is a globally shared object.
		once
		    create {HASH_TABLE [DEFINITION_FILE, STRING]} Result.make (10)

		    -- Create the file instances
		    Result.put(create {DEFINITION_FILE_PLACE}, "PLACE")
		end

end
