note
	description: "Definition file for OBJECT class"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFINITION_FILE_OBJECT

inherit

	DEFINITION_FILE
		redefine
			Definition_file_subdir,
			instantiate_object
		end

create {DEFINITION_FILE_REGISTRY}
	make_with_slug

feature {NONE} -- Constructor

	make_with_slug (the_slug: NON_EMPTY_STRING)
		do
			slug := the_slug
			create_object_from_definition
		end

feature {DEFINITION_FILE} -- Redefinitions

	Definition_file_subdir: STRING = "objects/"

	instantiate_object (xml_definition: XML_DEFINITION)
		local
			head_block: DEFINITION_BLOCK_OBJECT_HEAD
			id_block: DEFINITION_BLOCK_OBJECT_ID
			name_block: DEFINITION_BLOCK_OBJECT_NAME
			properties_block: DEFINITION_BLOCK_OBJECT_PROPERTIES
			description_block: DEFINITION_BLOCK_OBJECT_DESCRIPTION
		do
			create head_block.make_from_root_node (xml_definition.root_node)
			create id_block.make_from_root_node (xml_definition.root_node, slug)
			create name_block.make_from_root_node (xml_definition.root_node)
			create properties_block.make_from_root_node (xml_definition.root_node)
			create description_block.make_from_root_node (xml_definition.root_node)

			create {OBJECT} created_object.make (
				slug, head_block.author, name_block.object_name, properties_block.object_type, properties_block.object_category,
				properties_block.weight, properties_block.size, properties_block.price, properties_block.state, properties_block.aura,
				description_block.description
			)
		end

end
