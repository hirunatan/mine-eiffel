note
	description: "The <descripcion> node of an object definition file."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFINITION_BLOCK_OBJECT_DESCRIPTION

inherit
	EXCEPTIONS

create {DEFINITION_FILE_OBJECT}
	make_from_root_node

feature -- Constructor

	make_from_root_node (root_node: XML_DEFINITION_NODE)
		local
		    descripcion_node: XML_DEFINITION_NODE
		    difficulty_level: MAGNITUDE_INT_100
		    text: NON_EMPTY_STRING
		    description_item: OBJECT_DESCRIPTION_ITEM
		    item_name: STRING
		do
		    descripcion_node := root_node.required_sub_node("descripcion")
		    create description.make
		    across descripcion_node as item_cursor loop
				if not item_cursor.item.is_empty then
					item_name := item_cursor.item.name
					if not equal(item_name, "item") then
						raise ("Sub element of 'descripcion' must be 'item'")
					else
					    difficulty_level := item_cursor.item.magnitude_int_100_attribute("dificultad", 0)
					    text := item_cursor.item.non_empty_content
					    create description_item.make (difficulty_level, text)
					    description.extend (description_item)
					end
				end
		    end
		end

feature -- Access

    description: OBJECT_DESCRIPTION

end
