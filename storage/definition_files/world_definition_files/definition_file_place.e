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
		local
		    head_block: DEFINITION_BLOCK_PLACE_HEAD
		    id_block: DEFINITION_BLOCK_PLACE_ID
		    name_block: DEFINITION_BLOCK_PLACE_NAME
		    properties_block: DEFINITION_BLOCK_PLACE_PROPERTIES
		    description_block: DEFINITION_BLOCK_PLACE_DESCRIPTION
		    exits_block: DEFINITION_BLOCK_PLACE_EXITS
		do
			if attached slug as slg then
    			create head_block.make_from_root_node (xml_definition.root_node)
    			create id_block.make_from_root_node (xml_definition.root_node, slg)
    			create name_block.make_from_root_node (xml_definition.root_node)
    			create properties_block.make_from_root_node (xml_definition.root_node)
    			create description_block.make_from_root_node (xml_definition.root_node)
    			create exits_block.make_from_root_node (xml_definition.root_node)

    			create {PLACE} created_object.make (
    				slg, head_block.author, head_block.area_name, name_block.place_name, properties_block.aura, properties_block.place_type, properties_block.place_subtype,
    				properties_block.capacity, properties_block.light, properties_block.hiding_value, description_block.description, exits_block.exits
    			)
			end
		end

end
