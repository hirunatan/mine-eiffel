note
	description: "The <nombre> node of an object definition file."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFINITION_BLOCK_OBJECT_NAME

create {DEFINITION_FILE_OBJECT}
	make_from_root_node

feature -- Constructor

	make_from_root_node (root_node: XML_DEFINITION_NODE)
		local
		    nombre_node: XML_DEFINITION_NODE
		do
		    nombre_node := root_node.required_sub_node("nombre")
		    object_name := nombre_node.non_empty_content
		end

feature -- Access

	object_name: NON_EMPTY_STRING

end
