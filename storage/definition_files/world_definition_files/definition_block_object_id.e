note
	description: "The <id> node of an object definition file."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFINITION_BLOCK_OBJECT_ID

inherit
	EXCEPTIONS

create {DEFINITION_FILE_OBJECT}
	make_from_root_node

feature -- Constructor

	make_from_root_node (root_node: XML_DEFINITION_NODE; slug: NON_EMPTY_STRING)
		local
		    id_node: XML_DEFINITION_NODE
		    id_value: NON_EMPTY_STRING
		do
		    id_node := root_node.required_sub_node("id")
		    id_value := id_node.non_empty_content
		    if not equal(id_value.to_string, slug.to_string) then
		        raise ("The id '" + id_value.to_string + "' does not match with file name")
		    end
		end

end
