note
	description: "The <sala> node of a place definition file."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFINITION_BLOCK_PLACE_HEAD

create {DEFINITION_FILE_PLACE}
	make_from_root_node

feature -- Constructor

	make_from_root_node (root_node: XML_DEFINITION_NODE)
		do
			author := root_node.non_empty_string_attribute ("autor", Void)
			area_name := root_node.non_empty_string_attribute ("area", Void)
		end

feature -- Access

	author: NON_EMPTY_STRING

	area_name: NON_EMPTY_STRING

end
