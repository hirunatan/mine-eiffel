note
	description: "The <salidas> node of a place definition file."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFINITION_BLOCK_PLACE_EXITS

create {DEFINITION_FILE_PLACE}
	make_from_root_node

feature -- Constructor

	make_from_root_node (root_node: XML_DEFINITION_NODE)
		local
		    salidas_node: XML_DEFINITION_NODE
		    direction: NON_EMPTY_STRING
		    destination_place_slug: NON_EMPTY_STRING
		    difficulty_level: MAGNITUDE_INT_100
		    exit_description: NON_EMPTY_STRING
		    exit: PLACE_EXIT
		do
		    salidas_node := root_node.required_sub_node("salidas")
		    create {ARRAYED_LIST [PLACE_EXIT]} exits.make (0)
	    	across salidas_node as salida_cursor loop
	    		if not salida_cursor.item.is_empty then
					create direction.make_from_string (salida_cursor.item.name)
					destination_place_slug := salida_cursor.item.non_empty_string_attribute("id", Void)
				    difficulty_level := salida_cursor.item.magnitude_int_100_attribute("dificultad", 0)
				    exit_description := salida_cursor.item.non_empty_content
				    create exit.make (direction, destination_place_slug, difficulty_level, exit_description)
				    exits.extend (exit)
				end
			end
		end

feature -- Access

    exits: LIST [PLACE_EXIT]

end
