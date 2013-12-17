note
	description: "A real attribute that must have a value >= 0"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MAGNITUDE_REAL_POSITIVE

create
	make_from_real, make_from_integer

convert
	make_from_real ({REAL}),
	make_from_integer ({INTEGER}),
	to_real: {REAL}

feature

	make_from_real (r: REAL)
		require
			magnitude_range: r >= 0
		do
			lreal := r
		end

	make_from_integer (i: INTEGER)
		require
			magnitude_range: i >= 0
		do
			lreal := i
		end

	to_real: REAL
		do
			Result := lreal
		ensure
			magnitude_range: Result >= 0
		end

feature {NONE}

	lreal: expanded REAL

invariant
	magnitude_range: lreal >= 0

end
