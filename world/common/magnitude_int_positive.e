note
	description: "An integer attribute that must have a value >= 0"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MAGNITUDE_INT_POSITIVE

create
	make_from_integer

convert
	make_from_integer ({INTEGER}),
	to_integer: {INTEGER}

feature

	make_from_integer (i: INTEGER)
		require
			magnitude_range: i >= 0
		do
			linteger := i
		end

	to_integer: INTEGER
		do
			Result := linteger
		ensure
			magnitude_range: Result >= 0
		end

feature {NONE}

	linteger: expanded INTEGER

invariant
	magnitude_range: linteger >= 0

end
