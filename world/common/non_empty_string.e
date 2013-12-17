note
	description: "A string attribute that cannot be empty."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NON_EMPTY_STRING

create
	make_from_string

convert
	make_from_string ({STRING}),
	to_string: {STRING}

feature -- Conversion

	make_from_string (s: STRING)
		require
			not_is_empty: not s.is_empty
		do
			lstring := s
		end

	to_string: STRING
		do
			Result := lstring
		ensure
			not_is_empty: not Result.is_empty
		end

feature -- Operations

	plus alias "+" (s: READABLE_STRING_GENERAL): like s
		do
			Result := lstring + s
		end

feature {NONE}

	lstring: STRING

invariant
	not_is_empty: not lstring.is_empty

end
