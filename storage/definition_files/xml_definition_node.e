note
	description: "A node of a XML definition file. It has a name, attributes, content text and subnodes."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	XML_DEFINITION_NODE

inherit
	EXCEPTIONS
	ITERABLE [XML_DEFINITION_NODE]
		redefine
		    new_cursor
		end

create {XML_DEFINITION, XML_DEFINITION_NODE, XML_DEFINITION_CURSOR}
	make_empty, make_from_element

feature {NONE} -- Constructor

	make_empty
	do
	end

	make_from_element (the_element: XML_ELEMENT)
	do
	    element := the_element
	end

feature -- Access

	is_empty: BOOLEAN
	do
	    Result := (element = Void)
	end

	name: STRING
		require
		    not_empty: not is_empty
		do
			if attached element as elem then
				Result := elem.name
			else
			    Result := ""
			end
		end

	non_empty_string_attribute (attribute_name: STRING): NON_EMPTY_STRING
			-- Get a non empty string attribute, raise an exception if it does not exist or is not valid
		require
		    not_empty: not is_empty
		local
		    d_attr: detachable XML_ATTRIBUTE
		do
			if attached element as elem then
    		    d_attr := elem.attribute_by_name (attribute_name)
    		    if attached d_attr as attr and then not attr.value.is_empty then
    		    	create Result.make_from_string(attr.value.as_string_32)
    		    else
    				raise ("Cannot find attribute '" + attribute_name + "' of element '" + elem.name + "'")
    				Result := "xx"  -- Required by void safety, this will never execute
    		    end
    		else
    		    Result := "xx"  -- Required by void safety, this will never execute
			end
		end

	magnitude_int_100_attribute (attribute_name: STRING; default_value: detachable MAGNITUDE_INT_100): MAGNITUDE_INT_100
			-- Get a magnitude int 100 attribute of the element. If not exists and default_value is not void, return it;
			-- If it is void or the attribute is not valid, raise an exception.
		require
		    not_empty: not is_empty
		local
		    d_attr: detachable XML_ATTRIBUTE
		    attr_value: INTEGER
		do
			Result := 0
			if attached element as elem then
    		    d_attr := elem.attribute_by_name (attribute_name)
    		    if attached d_attr as attr and then not attr.value.is_empty then
    		    	if attr.value.is_integer then
    		    	    attr_value := attr.value.to_integer
    		    	    if attr_value >= 0 and attr_value <= 100 then
    		    	        Result := attr_value
    		    	    else
    		    	        raise ("Attribute '" + attribute_name + "' of element '" + elem.name + "' must be a number from 0 to 100")
    		    	    end
    		    	else
    		    	    raise ("Attribute '" + attribute_name + "' of element '" + elem.name + "' must be a number")
    		    	end
    		    else
    		    	if attached default_value then
    		    	    Result := default_value
    		    	else
    					raise ("Cannot find attribute '" + attribute_name + "' of element '" + elem.name + "'")
    		    	end
    		    end
    		end
		end

	magnitude_real_positive_attribute (attribute_name: STRING; default_value: detachable MAGNITUDE_REAL_POSITIVE): MAGNITUDE_REAL_POSITIVE
			-- Get a magnitude real positive attribute of the element. If not exists and default_value is not void, return it;
			-- If it is void or the attribute is not valid, raise an exception.
		require
		    not_empty: not is_empty
		local
		    d_attr: detachable XML_ATTRIBUTE
		    attr_value: REAL
		do
			create Result.make_from_real(0.0)
			if attached element as elem then
    		    d_attr := elem.attribute_by_name (attribute_name)
    		    if attached d_attr as attr and then not attr.value.is_empty then
    		    	if attr.value.is_real then
    		    	    attr_value := attr.value.to_real
    		    	    if attr_value >= 0 then
    		    	        Result := attr_value
    		    	    else
    		    	        raise ("Attribute '" + attribute_name + "' of element '" + elem.name + "' must be a decimal number greater than 0")
    		    	    end
    		    	else
    		    	    raise ("Attribute '" + attribute_name + "' of element '" + elem.name + "' must be a decimal number")
    		    	end
    		    else
    		    	if attached default_value then
    		    	    Result := default_value
    		    	else
    					raise ("Cannot find attribute '" + attribute_name + "' of element '" + elem.name + "'")
    		    	end
    		    end
    		end
    	end

	non_empty_content: NON_EMPTY_STRING
			-- Get the content text of the node, raise an exception if it does not contain any text
		require
		    not_empty: not is_empty
		local
		    d_content: detachable STRING
		    content_prune: STRING
		do
			if attached element as elem then
    			if attached elem.text as text then
    				d_content := text.as_string_32
    			end
    		    if attached d_content as content and then not content.is_empty then

    		    	-- The content may cointain extra blank space until the closing tag;
    		    	-- we need to remove it.
    		    	from
        		    	content_prune := ""
        		    	content_prune.copy (content)
    		    	until
    		    		not content_prune.ends_with(" ") and not content_prune.ends_with("%N")
    		    	loop
    		    		content_prune.prune_all_trailing ('%N')
    		    		content_prune.prune_all_trailing (' ')
    		    	end

    		    	Result := content_prune
    		    else
    				raise ("Cannot find content of element '" + elem.name + "'")
    				Result := "xx"  -- Required by void safety, this will never execute
    		    end
    		else
    			Result := "xx"  -- Required by void safety, this will never execute
    		end
    	end

	required_sub_node (node_name: STRING): XML_DEFINITION_NODE
			-- Get a sub node of this node, raise an exception if it does not exist
		require
		    not_empty: not is_empty
		local
		    d_subelement: detachable XML_ELEMENT
		do
			if attached element as elem then
    		    d_subelement := elem.element_by_name (node_name)
    		    if attached d_subelement as subelement then
    		    	create Result.make_from_element(subelement)
    		    else
    				raise ("Cannot find sub element '" + node_name + "' of element '" + elem.name + "'")
    				create Result.make_empty  -- Required by void safety, this will never execute
    		    end
    		else
				create Result.make_empty
    		end
    	end

	new_cursor: XML_DEFINITION_CURSOR
			-- An iterable cursor on subnodes
		require else
		    not_empty: not is_empty
		do
			if attached element as elem then
			    create Result.make_from_cursor (elem.new_cursor)
			else
			    create Result.make_empty  -- Required by void safety, this will never execute
			end
		end

feature {NONE} -- Implementation

	element: detachable XML_ELEMENT

end
