note
	description: "A cursor to iterate on subnodes of XML_DEFINITION_NODE."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	XML_DEFINITION_CURSOR

inherit
	ITERATION_CURSOR [XML_DEFINITION_NODE]

create
	make_from_cursor,
	make_empty

feature {NONE} -- Initialization

	make_from_cursor (cur: XML_COMPOSITE_CURSOR)
		do
			cursor := cur
			skip_non_elements
		end

	make_empty
		do
		end

feature -- Access

	is_empty: BOOLEAN
		do
			Result := (cursor = Void)
		end

	item: XML_DEFINITION_NODE
		require else
			not_empty: not is_empty
		local
			xml_node: XML_NODE
		do
			if attached cursor as cur then
				xml_node := cur.item
				if attached {XML_ELEMENT} xml_node as xml_element then
					create Result.make_from_element(xml_element)
				else
					create Result.make_empty
				end
			else
				create Result.make_empty
			end
		end

feature -- Cursor movement

	start
		require else
			not_empty: not is_empty
		do
			if attached cursor as cur then
				cur.start
			end
		end

	forth
		require else
			not_empty: not is_empty
		do
			if attached cursor as cur then
				cur.forth
				skip_non_elements
			end
		end

feature -- Status report

	after: BOOLEAN
		require else
			not_empty: not is_empty
		do
			if attached cursor as cur then
				Result := cur.after
			else
				Result := True
			end
		end

feature {NONE} -- Implementation

	cursor: detachable XML_COMPOSITE_CURSOR

	skip_non_elements
			-- Skip any node that is not a XML_ELEMENT
		require
			not_empty: not is_empty
		do
			if attached cursor as cur then
				from
				until
					cur.after or attached {XML_ELEMENT} cur.item as element
				loop
					cur.forth
				end
			end
		end

end
