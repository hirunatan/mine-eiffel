note
	description: "The <propiedades> node of a place definition file."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFINITION_BLOCK_PLACE_PROPERTIES

create {DEFINITION_FILE_PLACE}
	make_from_root_node

feature -- Constructor

	make_from_root_node (root_node: XML_DEFINITION_NODE)
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
		end

feature -- Access

    aura: MAGNITUDE_INT_100

    place_type: NON_EMPTY_STRING

    place_subtype: NON_EMPTY_STRING

    capacity: MAGNITUDE_REAL_POSITIVE

    light: MAGNITUDE_INT_100
    
    hiding_value: MAGNITUDE_INT_100

end
