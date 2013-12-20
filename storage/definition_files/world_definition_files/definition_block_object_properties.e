note
	description: "The <propiedades> node of an object definition file."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFINITION_BLOCK_OBJECT_PROPERTIES

create {DEFINITION_FILE_OBJECT}
	make_from_root_node

feature -- Constructor

	make_from_root_node (root_node: XML_DEFINITION_NODE)
		local
			propiedades_node: XML_DEFINITION_NODE
		do
			propiedades_node := root_node.required_sub_node("propiedades")
			object_type := propiedades_node.non_empty_string_attribute("tipo", create {NON_EMPTY_STRING}.make_from_string ("Tipo por defecto"))
			object_category := propiedades_node.non_empty_string_attribute("categoria", create {NON_EMPTY_STRING}.make_from_string ("Categoría por defecto"))
			weight := propiedades_node.magnitude_real_positive_attribute("peso", Void)
			size := propiedades_node.magnitude_real_positive_attribute("volumen", Void)
			price := propiedades_node.magnitude_real_positive_attribute("valor", Void)
			state := propiedades_node.magnitude_int_100_attribute("estado", Void)
			aura := propiedades_node.magnitude_int_100_attribute("aura", Void)
		end

feature -- Access

	object_type: NON_EMPTY_STRING

	object_category: NON_EMPTY_STRING

	weight: MAGNITUDE_REAL_POSITIVE

	size: MAGNITUDE_REAL_POSITIVE

	price: MAGNITUDE_REAL_POSITIVE

	state: MAGNITUDE_INT_100

	aura: MAGNITUDE_INT_100

end
