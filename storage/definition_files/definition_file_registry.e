note
	description: "A registry to get the definition file instance for some type inheriting from WORLD_STORABLE."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	DEFINITION_FILE_REGISTRY

feature -- Access to files

	get_definition_file_for (type: INTEGER; slug: NON_EMPTY_STRING): DEFINITION_FILE
			-- The instance of DEFINITION_FILE for the object of the given type with the given slug.
		require
			valid_type: (create {STORABLE_TYPE}).is_valid_type (type)
		do
			inspect type
			when {STORABLE_TYPE}.Place then
				create {DEFINITION_FILE_PLACE} Result.make_with_slug (slug)
			end
		end

end
