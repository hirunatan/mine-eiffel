note
	description: "A XML file that can be parsed and read at high level"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	XML_DEFINITION

create
	make_from_file

feature -- Constructor

	make_from_file(file: PLAIN_TEXT_FILE)
		require
			file_is_open_read: file.is_open_read
		local
			parser: XML_STOPPABLE_PARSER
			tree: XML_CALLBACKS_DOCUMENT
			resolver: XML_NAMESPACE_RESOLVER
		do
			create parser.make
			create tree.make_null
			create resolver.set_next (tree)
			parser.set_callbacks (resolver)
			parser.parse_from_file (file)
			if not parser.error_occurred and then (attached tree.document as document) then
				create root_node.make_from_element (document.root_element)
			else
				if attached parser.error_message as msg then
					last_error_message := "Error reading definition file: " + msg
				else
					last_error_message := "Error reading definition file"
				end
			end
		end

feature -- Access

	root_node: XML_DEFINITION_NODE
		attribute
			create Result.make_empty
		end

feature -- Status

	error_occurred: BOOLEAN
			-- True if the last call to create_object_from_def generated an error
			-- (or if it has not been called yet)
		do
			Result := not last_error_message.is_empty
		end

	last_error_message: STRING
			-- If error_occurred, here it is the message.
		attribute
			Result := ""
		end

invariant
	empty_node_if_error: error_occurred implies root_node.is_empty
	non_empty_node_if_no_error: not error_occurred implies not root_node.is_empty

end
