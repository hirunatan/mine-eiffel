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
		do
			storage.retrieve_object_by_slug ({STORABLE_TYPE}.Place, "poblado-calle01")
			if storage.error_occurred then
				print ("Error recuperando sala inicial: " + storage.last_error_message)
			else
    			if attached {PLACE} storage.retrieved_object as place then
    				current_place := place
    				show_current_place
    				main_loop
				end
			end
		end

feature {NONE} -- Implementation

	storage: WORLD_STORAGE

	current_place: detachable PLACE

	quit: BOOLEAN

	main_loop
		local
		    command: STRING
		    direction: NON_EMPTY_STRING
    	do
    		from
    		    quit := False
    		until
    		    quit = True
    		loop
    			print ("%N? ")
    			io.read_line
    		    command := io.last_string
    		    if equal(command, "+salir") then
    		    	print ("Adi�s, vuelve pronto...%N%N")
    		        quit := True
    		    elseif equal(command, "+norte") or equal(command, "+sur") or equal(command, "+este") or equal(command, "+oeste") or equal(command, "+arriba") or equal(command, "+abajo") then
    		    	create direction.make_from_string (command.substring (2, command.count))
    		    	move_to (direction)
    		    else
					print ("[
						Comando no reconocido, los comandos disponibles son
						  +direccion: moverse en la direcci�n indicada (norte, sur, ...)
						  +salir: terminar la ejecuci�n
					]")
    		    end
    		end
    	end

	show_current_place
		do
			if attached current_place as place then
        		print ("%N")
        		print ("Est�s en " + place.place_name.to_string + "%N%N")
        		print ("------- Descripci�n del lugar -------%N%N")
        		across place.description as desc_cursor loop
        			print (desc_cursor.item.text.to_string + "%N%N")
        		end
        		print ("--------------------------------------%N%N")
        		across place.exits as exits_cursor loop
        			print ("Hacia el " + exits_cursor.item.direction.to_string + " ves " + exits_cursor.item.description.to_string + "%N")
       			end
			end
		end

    move_to (direction: NON_EMPTY_STRING)
    	local
    		found: BOOLEAN
    	do
			if attached current_place as place then
	    		across place.exits as exits_cursor loop
	    			if equal(exits_cursor.item.direction.to_string, direction.to_string) then
	    				found := True
						storage.retrieve_object_by_slug ({STORABLE_TYPE}.Place, exits_cursor.item.destination_place_slug)
						if storage.error_occurred then
							print ("Error recuperando sala destino: " + storage.last_error_message)
						else
			    			if attached {PLACE} storage.retrieved_object as destination_place then
			    				current_place := destination_place
			    				show_current_place
			    			end
			    		end
	    			end
	    		end
	    		if not found then
	    			print ("No hay salida en direcci�n " + direction.to_string)
	    		end
	    	end
    	end

end
