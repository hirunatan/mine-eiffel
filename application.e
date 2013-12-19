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
			storage.retrieve_object_by_slug ({STORABLE_TYPE}.Place, "poblado-calle01")
			if not storage.error_occurred then
    			if attached {PLACE} storage.retrieved_object as place then
    				print ("%N")
					print ("Estás en " + place.place_name.to_string + "%N%N")
					print ("------- Descripción del lugar -------%N%N")
					across place.description as desc loop
						print (desc.item.text.to_string + "%N%N")
					end
    			    print ("--------------------------------------%N%N")
    			    across place.exits as exits loop
    			    	print ("Hacia el " + exits.item.direction.to_string + " ves " + exits.item.description.to_string + "%N")
    			    end
				end
			end
		end

end
