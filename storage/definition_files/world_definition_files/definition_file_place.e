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

	instantiate_object
		do
			if attached xml_root_element as root_element then
    			parse_sala (root_element)
    			parse_id (root_element)
    			parse_nombre (root_element)
    			parse_propiedades (root_element)
    			parse_descripcion (root_element)
    			parse_salidas (root_element)
				check_instantiate (slug, author, area_name, place_name, aura, place_type, place_subtype, capacity, light, hiding_value, description, exits)
			end
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

	parse_sala (root_element: XML_ELEMENT)
		do
	        author := non_empty_string_attribute(root_element, "autor")
	        area_name := non_empty_string_attribute(root_element, "area")
	    ensure
	        author_read: author /= Void
	        area_name_read: area_name /= Void
	    end

	parse_id (root_element: XML_ELEMENT)
		local
		    id_element: XML_ELEMENT
		    id_value: NON_EMPTY_STRING
		do
		    id_element := required_sub_element(root_element, "id")
		    id_value := non_empty_content(id_element)
		    if attached slug as the_slug and then not equal(id_value.to_string, the_slug.to_string) then
		        error("The id '" + id_value.to_string + "' does not match with file name")
		    end
		end

	parse_nombre (root_element: XML_ELEMENT)
		local
		    nombre_element: XML_ELEMENT
		do
		    nombre_element := required_sub_element(root_element, "nombre")
		    place_name := non_empty_content(nombre_element)
		ensure
		    place_name_read: place_name /= Void
		end

	parse_propiedades (root_element: XML_ELEMENT)
		local
		    propiedades_element: XML_ELEMENT
		do
		    propiedades_element := required_sub_element(root_element, "propiedades")
		    aura := magnitude_int_100_attribute(propiedades_element, "aura", Void)
			place_type := non_empty_string_attribute(propiedades_element, "tipo")
			place_subtype := non_empty_string_attribute(propiedades_element, "subtipo")
			capacity := magnitude_real_positive_attribute(propiedades_element, "volumen", Void)
			light := magnitude_int_100_attribute(propiedades_element, "luz", Void)
			hiding_value := magnitude_int_100_attribute(propiedades_element, "ocultabilidad", Void)
		ensure
		    aura_read: aura /= Void
		    place_type_read: place_type /= Void
		    place_subtype_read: place_subtype /= Void
		    capacity_read: capacity /= Void
		    light_read: light /= Void
		    hiding_value_read: hiding_value /= Void
		end

	parse_descripcion (root_element: XML_ELEMENT)
		local
		    descripcion_element: XML_ELEMENT
		    difficulty_level: MAGNITUDE_INT_100
		    text: NON_EMPTY_STRING
		    description_item: PLACE_DESCRIPTION_ITEM
		    item_name: STRING
		do
		    descripcion_element := required_sub_element(root_element, "descripcion")
		    create {ARRAYED_LIST [PLACE_DESCRIPTION_ITEM]} description.make (0)
		    if attached description as l_description then
		    	across descripcion_element as desc loop
    				if attached {XML_ELEMENT} desc.item as item_element then
    					item_name := item_element.name
    					if not equal(item_name, "item") then
    						error("Sub element of 'descripcion' must be 'item'")
    					else
    					    difficulty_level := magnitude_int_100_attribute(item_element, "dificultad", 0)
    					    text := non_empty_content(item_element)
    					    create description_item.make (difficulty_level, text)
    					    l_description.extend (description_item)
    					end
    				end
    			end
		    end
		end

	parse_salidas (root_element: XML_ELEMENT)
		local
		    salidas_element: XML_ELEMENT
		    direction: NON_EMPTY_STRING
		    destination_place_slug: NON_EMPTY_STRING
		    difficulty_level: MAGNITUDE_INT_100
		    exit_description: NON_EMPTY_STRING
		    exit: PLACE_EXIT
		do
		    salidas_element := required_sub_element(root_element, "salidas")
		    create {ARRAYED_LIST [PLACE_EXIT]} exits.make (0)
		    if attached exits as l_exits then
		    	across salidas_element as salidas loop
    				if attached {XML_ELEMENT} salidas.item as salida_element then
    					create direction.make_from_string (salida_element.name)
    					destination_place_slug := non_empty_string_attribute(salida_element, "id")
					    difficulty_level := magnitude_int_100_attribute(salida_element, "dificultad", 0)
					    exit_description := non_empty_content(salida_element)
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
