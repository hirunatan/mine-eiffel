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
			Definition_file_subdir, create_object_from_def
		end

feature -- Redefinitions

	Definition_file_subdir: STRING = "places/"

	create_object_from_def (slug: NON_EMPTY_STRING): detachable PLACE
		local
		    xml_element: XML_ELEMENT
		do
			read_xml_file(slug)
			if attached xml_root_element as root then
    			xml_element := root
    			from
    				xml_element.start
    			until
    				xml_element.after
    			loop
    				if attached {XML_ELEMENT} xml_element.item_for_iteration as xml_subelement then
    				    print (xml_subelement.name + "%N")
    				end
    				xml_element.forth
    			end
			end
			if slug.to_string.starts_with ("test") then
				create Result.make(slug)
			else
			    Result := Void
			    last_error_message := "Slug don't found"
			end
		end

end
