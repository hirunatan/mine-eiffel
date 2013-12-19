note
	description: "The list of possible types of storable objects."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STORABLE_TYPE

	 -- This should be a better implementation of an ENUM type
	 -- For example, see http://dev.eiffel.com/Enums_in_Eiffel

feature -- Enum values

    Place: INTEGER = 1

feature -- Validation

    is_valid_type(type: INTEGER): BOOLEAN
    	do
    	    Result := (type = Place)
    	end

end
