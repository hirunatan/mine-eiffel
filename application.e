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
			storage.retrieve_object_by_slug ("PLACE", "poblado-calle01")
			if not storage.error_occurred then
				print ("funsiona")
			end
		end

end
