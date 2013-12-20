note
	description: "The <objetos> node of a place definition file."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFINITION_BLOCK_PLACE_OBJECTS

create {DEFINITION_FILE_PLACE}
	make_from_root_node

feature -- Constructor

	make_from_root_node (root_node: XML_DEFINITION_NODE)
		local
			objetos_node: XML_DEFINITION_NODE
			object_slug: NON_EMPTY_STRING
			probability: MAGNITUDE_INT_100
			maximum: MAGNITUDE_INT_POSITIVE
			difficulty_level: MAGNITUDE_INT_100
			quantity: MAGNITUDE_INT_POSITIVE
			object_description: NON_EMPTY_STRING
			place_object: PLACE_OBJECT
		do
			objetos_node := root_node.required_sub_node("objetos")
			create {PLACE_OBJECTS} place_objects.make
			across objetos_node as objeto_cursor loop
				if not objeto_cursor.item.is_empty then
					object_slug := objeto_cursor.item.non_empty_string_attribute("id", Void)
					probability := objeto_cursor.item.magnitude_int_100_attribute("probabilidad", 0)
					maximum := objeto_cursor.item.magnitude_int_positive_attribute("maximo", 0)
					difficulty_level := objeto_cursor.item.magnitude_int_100_attribute("dificultad", 0)
					quantity := objeto_cursor.item.magnitude_int_positive_attribute("cantidad", 0)
					object_description := objeto_cursor.item.non_empty_content
					create place_object.make (object_slug, probability, maximum, difficulty_level, quantity, object_description)
					place_objects.extend (place_object)
				end
			end
		end

feature -- Access

	place_objects: PLACE_OBJECTS

end
