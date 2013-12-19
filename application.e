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
    			print (color(33) + "%N? " + color(37))
    			io.read_line
    		    command := io.last_string
    		    if equal(command, "+salir") then
    		    	print ("Adiós, vuelve pronto...%N%N")
    		        quit := True
    		    elseif equal(command, "+norte") or equal(command, "+sur") or equal(command, "+este") or equal(command, "+oeste") or equal(command, "+arriba") or equal(command, "+abajo") then
    		    	create direction.make_from_string (command.substring (2, command.count))
    		    	move_to (direction)
    		    else
					print ("[
						Comando no reconocido, los comandos disponibles son
						  +direccion: moverse en la dirección indicada (norte, sur, ...)
						  +salir: terminar la ejecución
					]")
    		    end
    		end
    	end

	show_current_place
		do
			if attached current_place as place then
        		print ("%N")
        		print (color(31) + "Estás en " + place.place_name.to_string + "%N%N")
        		print (color(37) + "------- Descripción del lugar -------%N%N")
        		across place.description as desc_cursor loop
        			print (desc_cursor.item.text.to_string + "%N%N")
        		end
        		print ("--------------------------------------%N%N")
        		across place.exits as exits_cursor loop
        			print (color(36) + "Hacia el " + exits_cursor.item.direction.to_string + " ves " + exits_cursor.item.description.to_string + "%N")
       			end
       			if place.objects.count > 0 then
       				print (color(32) + "%NAquí hay:%N")
       				across place.objects as objects_cursor loop
       					print (objects_cursor.item.description + "%N")
       				end
       			end
       			print (color(37))
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
	    			print ("No hay salida en dirección " + direction.to_string)
	    		end
	    	end
    	end

	color (color_number: INTEGER): STRING
			-- ANSI codes to change the terminal text color
		do
			Result := "%/27/[0;" + color_number.out + "m"
		end

end
