note
	description: "The <objeto> node of an object definition file."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFINITION_BLOCK_OBJECT_HEAD

create {DEFINITION_FILE_OBJECT}
	make_from_root_node

feature -- Constructor

	make_from_root_node (root_node: XML_DEFINITION_NODE)
		do
			author := root_node.non_empty_string_attribute ("autor", Void)
		end

feature -- Access

	author: NON_EMPTY_STRING

end
