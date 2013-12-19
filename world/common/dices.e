note
	description: "A set of dices to make random rolls"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	DICES

feature -- Rolls

	roll_1d100
			-- Roll one dice of 100 heads
		do
			random.forth
			roll_result := random.item \\ 100 + 1
		end

	roll_result: INTEGER

feature {NONE} -- Implementation

	random: RANDOM
		once
			create Result.make
		end

end
