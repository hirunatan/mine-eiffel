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
			storage.retrieve_object_by_slug ({STORABLE_TYPE}.Place, "poblado-camino01")
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

	dices: DICES

	quit: BOOLEAN

	main_loop
		local
		    command: STRING
    	do
    		from
    		    quit := False
    		until
    		    quit = True
    		loop
    			print (color(33) + "%N? " + color(37))
    			io.read_line
    		    command := io.last_string
    		    process_command (command)
    		end
    	end

    process_command (command: STRING)
    	do
   		    if equal(command, "+salir") then
   		    	print ("Adiós, vuelve pronto...%N%N")
   		        quit := True
   		    elseif movement_commands.has_key (command) then
   		    	if attached movement_commands[command] as dir then
 	  		    	move_to (dir)
   		    	end
   		    else
				print ("[
					Comando no reconocido, los comandos disponibles son
					  +direccion: moverse en la dirección indicada (norte, sur, ...)
					  +salir: terminar la ejecución
				]")
    	    end
    	end

	show_current_place
		local
			first: BOOLEAN
			perception_roll: INTEGER
		do
			if attached current_place as place then
				dices.roll_1d100
				perception_roll := dices.roll_result

        		print ("%N")
        		print (color(31) + "Estás en " + place.place_name.to_string + "%N%N")
        		print (color(37) + "------- Descripción del lugar -------%N%N")
        		across place.description as desc_cursor loop
        			if perception_roll > desc_cursor.item.difficulty_level.to_integer then
        				print (desc_cursor.item.text.to_string + "%N%N")
        			end
        		end
        		print ("--------------------------------------%N%N")
        		across place.exits as exits_cursor loop
        			if perception_roll > exits_cursor.item.difficulty_level.to_integer then
	        			print (color(36))
	        			if equal(exits_cursor.item.direction.to_string, "arriba") or equal(exits_cursor.item.direction.to_string, "abajo") then
	        				print ("Hacia " + exits_cursor.item.direction.to_string)
	        			else
	        				print ("Hacia el " + exits_cursor.item.direction.to_string)
	        			end
	        			print (" ves " + exits_cursor.item.description.to_string + "%N")
	        		end
       			end
       			first := True
       			across place.objects as objects_cursor loop
       				if objects_cursor.item.instances.count > 0 then
	        			if perception_roll > objects_cursor.item.difficulty_level.to_integer then
		       				if first then
		       					print (color(32) + "%NAquí hay:%N")
		       					first := False
		       				end
		       				print (objects_cursor.item.description.to_string)
		       				if objects_cursor.item.instances.count > 1 then
		       					print (" (" + objects_cursor.item.instances.count.out + ")")
		       				end
		       				print ("%N")
		       			end
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

	movement_commands: HASH_TABLE [STRING, STRING]
		once
			create {HASH_TABLE [STRING, STRING]} Result.make (0)
			Result.put ("norte", "+norte")
			Result.put ("norte", "+n")
			Result.put ("noreste", "+noreste")
			Result.put ("noreste", "+ne")
			Result.put ("este", "+este")
			Result.put ("este", "+e")
			Result.put ("sureste", "+sureste")
			Result.put ("sureste", "+se")
			Result.put ("sur", "+sur")
			Result.put ("sur", "+s")
			Result.put ("suroeste", "+suroeste")
			Result.put ("suroeste", "+so")
			Result.put ("oeste", "+oeste")
			Result.put ("oeste", "+o")
			Result.put ("noroeste", "+noroeste")
			Result.put ("noroeste", "+no")
			Result.put ("arriba", "+arriba")
			Result.put ("arriba", "+ar")
			Result.put ("abajo", "+abajo")
			Result.put ("abajo", "+ab")
		end

end
