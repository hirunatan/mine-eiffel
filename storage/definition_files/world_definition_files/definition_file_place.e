note
	description: "Definition file for PLACE class"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFINITION_FILE_PLACE

inherit

	DEFINITION_FILE
		redefine
			Definition_file_subdir,
			instantiate_object
		end

feature {DEFINITION_FILE} -- Redefinitions

	Definition_file_subdir: STRING = "places/"

	instantiate_object (xml_definition: XML_DEFINITION)
		do
			parse_sala (xml_definition.root_node)
			parse_id (xml_definition.root_node)
			parse_nombre (xml_definition.root_node)
			parse_propiedades (xml_definition.root_node)
			parse_descripcion (xml_definition.root_node)
			parse_salidas (xml_definition.root_node)
			check_instantiate (slug, author, area_name, place_name, aura, place_type, place_subtype, capacity, light, hiding_value, description, exits)
		end

	check_instantiate(the_slug: detachable NON_EMPTY_STRING; the_author: detachable NON_EMPTY_STRING; the_area_name: detachable NON_EMPTY_STRING; the_place_name: detachable NON_EMPTY_STRING;
	      the_aura: detachable MAGNITUDE_INT_100; the_place_type: detachable NON_EMPTY_STRING; the_place_subtype: detachable NON_EMPTY_STRING;
	      the_capacity: detachable MAGNITUDE_REAL_POSITIVE; the_light: detachable MAGNITUDE_INT_100; the_hiding_value: detachable MAGNITUDE_INT_100;
	      the_description: detachable LIST [PLACE_DESCRIPTION_ITEM]; the_exits: detachable LIST [PLACE_EXIT])
		do
			if the_slug /= Void and the_author /= Void and the_area_name /= Void and the_place_name /= Void and the_aura /= Void and the_place_type /= Void and the_place_subtype /= Void
			   and the_capacity /= Void and the_light /= Void and the_hiding_value /= Void and the_description /= Void and the_exits /= Void then
				create {PLACE} created_object.make (the_slug, the_author, the_area_name, the_place_name, the_aura, the_place_type, the_place_subtype, the_capacity, the_light, the_hiding_value, the_description, the_exits)
			end
		end

feature {NONE} -- XML parsing

	parse_sala (root_node: XML_DEFINITION_NODE)
		do
	        author := root_node.non_empty_string_attribute("autor")
	        area_name := root_node.non_empty_string_attribute("area")
	    ensure
	        author_read: author /= Void
	        area_name_read: area_name /= Void
	    end

	parse_id (root_node: XML_DEFINITION_NODE)
		local
		    id_node: XML_DEFINITION_NODE
		    id_value: NON_EMPTY_STRING
		do
		    id_node := root_node.required_sub_node("id")
		    id_value := id_node.non_empty_content
		    if attached slug as the_slug and then not equal(id_value.to_string, the_slug.to_string) then
		        error("The id '" + id_value.to_string + "' does not match with file name")
		    end
		end

	parse_nombre (root_node: XML_DEFINITION_NODE)
		local
		    nombre_node: XML_DEFINITION_NODE
		do
		    nombre_node := root_node.required_sub_node("nombre")
		    place_name := nombre_node.non_empty_content
		ensure
		    place_name_read: place_name /= Void
		end

	parse_propiedades (root_node: XML_DEFINITION_NODE)
		local
		    propiedades_node: XML_DEFINITION_NODE
		do
		    propiedades_node := root_node.required_sub_node("propiedades")
		    aura := propiedades_node.magnitude_int_100_attribute("aura", Void)
			place_type := propiedades_node.non_empty_string_attribute("tipo")
			place_subtype := propiedades_node.non_empty_string_attribute("subtipo")
			capacity := propiedades_node.magnitude_real_positive_attribute("volumen", Void)
			light := propiedades_node.magnitude_int_100_attribute("luz", Void)
			hiding_value := propiedades_node.magnitude_int_100_attribute("ocultabilidad", Void)
		ensure
		    aura_read: aura /= Void
		    place_type_read: place_type /= Void
		    place_subtype_read: place_subtype /= Void
		    capacity_read: capacity /= Void
		    light_read: light /= Void
		    hiding_value_read: hiding_value /= Void
		end

	parse_descripcion (root_node: XML_DEFINITION_NODE)
		local
		    descripcion_node: XML_DEFINITION_NODE
		    difficulty_level: MAGNITUDE_INT_100
		    text: NON_EMPTY_STRING
		    description_item: PLACE_DESCRIPTION_ITEM
		    item_name: STRING
		do
		    descripcion_node := root_node.required_sub_node("descripcion")
		    create {ARRAYED_LIST [PLACE_DESCRIPTION_ITEM]} description.make (0)
		    if attached description as l_description then
		    	across descripcion_node as item_cursor loop
    				if not item_cursor.item.is_empty then
    					item_name := item_cursor.item.name
    					if not equal(item_name, "item") then
    						error("Sub element of 'descripcion' must be 'item'")
    					else
    					    difficulty_level := item_cursor.item.magnitude_int_100_attribute("dificultad", 0)
    					    text := item_cursor.item.non_empty_content
    					    create description_item.make (difficulty_level, text)
    					    l_description.extend (description_item)
    					end
    				end
    			end
		    end
		end

	parse_salidas (root_node: XML_DEFINITION_NODE)
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
		    if attached exits as l_exits then
		    	across salidas_node as salida_cursor loop
		    		if not salida_cursor.item.is_empty then
    					create direction.make_from_string (salida_cursor.item.name)
    					destination_place_slug := salida_cursor.item.non_empty_string_attribute("id")
					    difficulty_level := salida_cursor.item.magnitude_int_100_attribute("dificultad", 0)
					    exit_description := salida_cursor.item.non_empty_content
					    create exit.make (direction, destination_place_slug, difficulty_level, exit_description)
					    l_exits.extend (exit)
    				end
    			end
		    end
		end

feature {NONE} -- Attributes

	author: detachable NON_EMPTY_STRING
	area_name: detachable NON_EMPTY_STRING
	place_name: detachable NON_EMPTY_STRING
    aura: detachable MAGNITUDE_INT_100
    place_type: detachable NON_EMPTY_STRING
    place_subtype: detachable NON_EMPTY_STRING
    capacity: detachable MAGNITUDE_REAL_POSITIVE
    light: detachable MAGNITUDE_INT_100
    hiding_value: detachable MAGNITUDE_INT_100
    description: detachable LIST [PLACE_DESCRIPTION_ITEM]
    exits: detachable LIST [PLACE_EXIT]

end
