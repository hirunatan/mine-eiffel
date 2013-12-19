note
	description: "A set of dices to make random rolls"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DICES

create
	make

feature {NONE} -- Constructor

	make
		do
			create random.make
		end

feature -- Rolls

	forth
			-- Get the next roll
		do
			random.forth
		end

	roll_1d100: INTEGER
			-- Get the roll as a 1d100
		do
			Result := random.item \\ 100 + 1
		end

feature -- Implementation

	random: RANDOM

end
