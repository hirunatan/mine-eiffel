note
	description: "mine-eiffel application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit

	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			storage: WORLD_STORAGE
		do
			create storage
			if attached {PLACE} storage.get_object_by_slug ("PLACE", "poblado-calle01") as retrieved_place then
				print ("funsiona")
			end
		end

end
