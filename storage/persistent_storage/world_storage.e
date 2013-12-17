note
	description: "A persistent storage for WORLD_STORABLE objects."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORLD_STORAGE

feature -- Access

	store_object (type: STRING; object: WORLD_STORABLE)
			-- Store an object of a type with all its contents into world storage.
		local
			file_name: STRING
			file: RAW_FILE
		do
			-- Currently the type is ignored
			file_name := file_name_for_slug (object.slug)
			create file.make_open_write (file_name)
			file.independent_store (object)
			file.close
		end

	-- TODO: separate command / query
	get_object_by_slug (type: STRING; slug: NON_EMPTY_STRING): detachable WORLD_STORABLE
			-- Retrieve an object with all its contents from world storage, if stored.
			-- If not, try to create the object from a definition file, if exists.
			-- If the file does not exist (or is unreadable), return Void and sets an error message.
		local
			file: detachable RAW_FILE
			registry: DEFINITION_FILE_REGISTRY
			definition_file: DEFINITION_FILE
		do
			create file.make_with_name (file_name_for_slug (slug))
			if file.access_exists then
				create file.make_open_read (file_name_for_slug (slug))
				if attached {WORLD_STORABLE} file.retrieved as retrieved_object then
					Result := retrieved_object
					last_error_message := ""
				else
					Result := Void
					last_error_message := "Object file with slug '" + slug.to_string + "' is broken"
				end
			else
    			definition_file := registry.get_definition_file_for(type)
    			if attached definition_file.create_object_from_def (slug) as retrieved_object then
    				Result := retrieved_object
    				last_error_message := ""
    			else
    				Result := Void
    				last_error_message := "Cannot find object with slug '" + slug.to_string + "'"
    			end
    		end
		rescue
			if attached file and then file.is_open_read then
				file.close
			end
		end

feature -- Status

	last_error_message: STRING
			-- If last call to create_object_from_def generated an error, here it is the message.
		attribute
			Result := ""
		end

feature {NONE} -- Configuration constants

	World_storage_dir: STRING = "data/world_storage/"

	Storage_file_extension: STRING = ".object"

feature {NONE} -- Implementation

	file_name_for_slug (slug: NON_EMPTY_STRING): STRING
		do
			Result := World_storage_dir + slug.to_string + Storage_file_extension
		end

end
